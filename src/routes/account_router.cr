get "/clientes/:id/extrato" do |env|
  env.response.content_type = "application/json"
  account_id = env.params.url["id"].to_i32

  if account_id >= 1 && account_id <= 5
    account = Account.find!(account_id)
    transactions = Transaction.get_account_transactions(account_id)

    {
      saldo: {
        total: account.balance,
        data_extrato: Time.utc,
        limite: account.limit_amount
      },
      ultimas_transacoes: transactions.map do |transaction|
        {
          valor: transaction.amount,
          tipo: transaction.type,
          descricao: transaction.description,
          realizada_em: transaction.created_at
        }
      end
    }.to_json
  else
    env.response.status_code = 404
  end
end

post "/clientes/:id/transacoes" do |env|
  env.response.content_type = "application/json"
  account_id = env.params.url["id"].to_i32
  type = env.params.json["tipo"].as(String)
  description = env.params.json["descricao"] ? env.params.json["descricao"].as(String) : nil
  amount = env.params.json["valor"] && env.params.json["valor"].is_a?(Int64) ? env.params.json["valor"].as(Int64).to_i : nil

  if account_id >= 1 && account_id <= 5
    begin
      transaction = Transaction.new({
        account_id: account_id,
        amount: amount,
        type: type,
        description: description
      })

      TransactionCreator.new(transaction).create

      {
        limite: transaction.account!.limit_amount,
        saldo: transaction.account!.balance
      }.to_json
    rescue exception
      env.response.status_code = 422
    end
  else
    env.response.status_code = 404
  end
end
