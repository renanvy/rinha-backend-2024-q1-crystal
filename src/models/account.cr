class Account < Jennifer::Model::Base
  mapping(
    id: Primary32,
    balance: { type: Int32, default: 0 },
    limit_amount: Int32,
  )

  validates_with_method :limit_reached?

  def self.create_transaction(transaction)
    Jennifer::Adapter.default_adapter.transaction do |tx|
      account = Account.all.lock.find!(transaction.account_id)
      account.balance = calculate_balance(account, transaction)
      # raise "limit reached!" if self.limit_reached?(account, transaction)

      account.update

      transaction.save!
    end
  end

  def self.limit_reached?(account, transaction)
    transaction.type == "d" && account.balance.abs > account.limit_amount
  end

  def self.calculate_balance(account, transaction)
    if transaction.type == "c"
      account.balance + transaction.amount
    elsif transaction.type == "d"
      account.balance - transaction.amount
    end
  end

  def limit_reached?
    # errors.add(:balance, "limit reached!")
  end
end
