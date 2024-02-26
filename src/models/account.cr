class Account < Jennifer::Model::Base
  mapping(
    id: Primary32,
    balance: { type: Int32, default: 0 },
    limit_amount: Int32,
  )

  validates_with_method :limit_reached?

  def limit_reached?
    if balance < 0 && balance.abs > limit_amount
      errors.add(:account, "limit reached!")
    end
  end
end
