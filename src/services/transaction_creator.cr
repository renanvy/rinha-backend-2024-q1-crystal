class TransactionCreator
  getter :transaction

  def initialize(transaction : Transaction)
    @transaction = transaction
  end

  def create
    Jennifer::Adapter.default_adapter.transaction do |tx|
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
