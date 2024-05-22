defmodule BankDigitalApiWeb.TransactionController do
  use BankDigitalApiWeb, :controller

  alias BankDigitalApi.Service.{Account, Transaction}
  alias BankDigitalApi.Schemas.Transaction, as: TransactionSchema

  action_fallback BankDigitalApiWeb.FallbackController

  def create(conn, %{
        "account_number" => account_number,
        "payment_method" => payment_method,
        "amount" => amount
      }) do
    transaction_map = %{
      account_number: account_number,
      payment_method: payment_method,
      amount: amount
    }

    with {:ok, account} <- Account.validate_account_exists(account_number),
         {:ok, %TransactionSchema{} = transaction} <-
           Transaction.create_transaction(account, transaction_map) do
      conn
      |> put_status(:created)
      |> put_view(BankDigitalApiWeb.TransactionView)
      |> render("show.json", transaction: transaction)
    else
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(BankDigitalApiWeb.ErrorView)
        |> render("404.json")

      {:error, :insufficient_funds} ->
        conn
        |> put_status(:not_found)
        |> put_view(BankDigitalApiWeb.TransactionView)
        |> render("error.json", message: "saldo insuficiente")

      {:error, :invalid_payment_method} ->
        conn
        |> put_status(:not_found)
        |> put_view(BankDigitalApiWeb.TransactionView)
        |> render("error.json", message: "forma de pagamento inválida")
    end
  end
end
