defmodule BankDigitalApiWeb.AccountView do
  use BankDigitalApiWeb, :view

  def render("show.json", %{account: account}) do
    %{
      account_number: account.account_number,
      balance: account.balance
    }
  end
end
