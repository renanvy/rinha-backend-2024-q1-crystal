class TransactionCreator
  getter :transaction

  def initialize(transaction : Transaction)
    @transaction = transaction
  end

  def create
    account = Account.find!(transaction.account_id)

    account.with_lock do
      raise "Invalid transaction" unless transaction.valid?

      account = Account.all.lock.find!(transaction.account_id)
      account.balance = calculate_balance(account, transaction)
      account.update!
      transaction.save!
    end
  end

  private def calculate_balance(account, transaction)
    if transaction.type == "c"
      account.balance + transaction.amount!
    elsif transaction.type == "d"
      account.balance - transaction.amount!
    end
  end
end
