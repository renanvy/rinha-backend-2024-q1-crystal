class Account < Jennifer::Model::Base
  mapping(
    id: Primary32,
    balance: { type: Int32, default: 0 },
    limit_amount: Int32,
    latest_transactions: [] of JSON::Any
  )

  def self.create_transaction(transaction)
    raise "Transaction not valid" unless transaction_valid?(transaction)

    Jennifer::Adapter.default_adapter.transaction do |tx|
      account = Account.all.lock.find!(transaction[:account_id])
      account.balance = calculate_balance(account, transaction)
      latest_transactions = account.latest_transactions
      latest_transactions << transaction.to_json
      account.latest_transactions = latest_transactions

      if limit_reached?(account)
        raise "Limit reached"
      else
        account.update!
      end
    end
  end

  private def self.limit_reached?(account)
    account.balance < 0 && account.balance.abs > account.limit_amount
  end

  private def self.calculate_balance(account, transaction)
    if transaction[:type] == "c"
      account.balance + transaction[:amount]
    elsif transaction[:type] == "d"
      account.balance - transaction[:amount]
    end
  end

  private def self.transaction_valid?(transaction)
    transaction[:amount] > 0
  end
end
