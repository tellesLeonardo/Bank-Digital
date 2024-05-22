defmodule BankDigitalApiWeb.AccountView do
  use BankDigitalApiWeb, :view

  def render("show.json", %{account: account}) do
    %{
      numero_conta: account.account_number,
      saldo: account.balance
    }
  end
end
