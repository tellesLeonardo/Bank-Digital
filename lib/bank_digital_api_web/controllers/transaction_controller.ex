defmodule BankDigitalApiWeb.TransactionController do
  use BankDigitalApiWeb, :controller

  alias BankDigitalApi.Service.{Account, Transaction}
  alias BankDigitalApi.Schemas.Transaction, as: TransactionSchema

  action_fallback BankDigitalApiWeb.FallbackController

  def create(conn, %{
        "numero_conta" => numero_conta,
        "forma_pagamento" => forma_pagamento,
        "valor" => valor
      }) do
    transaction_map = %{
      numero_conta: numero_conta,
      forma_pagamento: forma_pagamento,
      valor: valor
    }

    with {:ok, account} <- Account.validate_account_exists(numero_conta),
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

      {:error, :invalid_forma_pagamento} ->
        conn
        |> put_status(:not_found)
        |> put_view(BankDigitalApiWeb.TransactionView)
        |> render("error.json", message: "forma de pagamento inválida")
    end
  end
end
