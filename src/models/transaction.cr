class Transaction < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: Primary32,
    amount: Int32?,
    type: String?,
    description: String?,
    account_id: Int32?,
    created_at: Time?,
    updated_at: Time?
  )

  belongs_to :account, Account

  validates_presence :amount
  validates_presence :type
  validates_presence :description
  validates_presence :account_id
  validates_length :description, in: 1..10
  validates_inclusion :type, in: ["d", "c"]
  validates_numericality :amount, greater_than: 0

  validates_with_method :limit_reached?

  def self.get_account_transactions(account_id)
    Transaction
      .where { _account_id == account_id }
      .order(created_at: :desc)
      .limit(10).to_a
  end

  def limit_reached?
    return if account.nil?
    return if type != "d"

    new_balance = account!.balance - amount!

    if new_balance.abs > account!.limit_amount
      errors.add(:account, "limit reached!")
    end
  end
end
