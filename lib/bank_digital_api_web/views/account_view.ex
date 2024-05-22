defmodule BankDigitalApiWeb.AccountView do
  use BankDigitalApiWeb, :view

  def render("show.json", %{account: account}) do
    %{
      numero_conta: account.numero_conta,
      saldo: account.saldo
    }
  end
end
