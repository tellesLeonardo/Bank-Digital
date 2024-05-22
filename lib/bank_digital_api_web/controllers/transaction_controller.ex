defmodule BankDigitalApiWeb.TransactionController do
  use BankDigitalApiWeb, :controller

  # alias BankDigitalApi.Schema.{Account, Transaction}
  # alias BankDigitalApi.Repo
  # alias BankDigitalApiWeb.TransactionView

  action_fallback BankDigitalApiWeb.FallbackController


  def create(conn, %{"account_number" => _account_number, "payment_method" => _payment_method, "amount" => _amount}) do
    conn
  end

end
