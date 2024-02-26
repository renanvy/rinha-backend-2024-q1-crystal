class Account < Jennifer::Model::Base
  mapping(
    id: Primary32,
    balance: { type: Int32, default: 0 },
    limit_amount: Int32,
  )
end
