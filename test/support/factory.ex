defmodule BankDigitalApi.Factory do
  use ExMachina.Ecto, repo: BankDigitalApi.Repo

  alias BankDigitalApi.Schemas.{Account, Transaction}

  def account_factory do
    %Account{
      account_number: sequence(:account_number, & &1),
      balance: Decimal.new("1000.00")
    }
  end

  def transaction_factory do
    account = insert(:account)

    %Transaction{
      account_number: account.account_number,
      payment_method: "C",
      amount: Decimal.new("100.00"),
      timestamp: NaiveDateTime.utc_now()
    }
  end
end
