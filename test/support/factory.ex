defmodule BankDigitalApi.Factory do
  use ExMachina.Ecto, repo: BankDigitalApi.Repo

  alias BankDigitalApi.Schemas.{Account, Transaction}

  def account_factory do
    %Account{
      numero_conta: sequence(:numero_conta, & &1),
      saldo: Decimal.new("1000.00")
    }
  end

  def transaction_factory do
    account = insert(:account)

    %Transaction{
      numero_conta: account.numero_conta,
      forma_pagamento: "C",
      valor: Decimal.new("100.00"),
      timestamp: NaiveDateTime.utc_now()
    }
  end
end
