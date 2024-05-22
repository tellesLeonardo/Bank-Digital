defmodule BankDigitalApiWeb.AccountController do
  use BankDigitalApiWeb, :controller

  alias BankDigitalApi.Service.Account
  alias BankDigitalApiWeb.AccountView

  action_fallback BankDigitalApiWeb.FallbackController

  def create(conn, attrs) do
    with {:error, :not_found} <-
           Account.validate_account_exists(attrs["account_number"]) do
      case Account.create_account(attrs) do
        {:ok, account} ->
          conn
          |> put_status(:created)
          |> put_view(AccountView)
          |> render("show.json", account: account)

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(BankDigitalApiWeb.ChangesetView)
          |> render("error.json", changeset: changeset)
      end
    else
      {:ok, account} ->
        conn
        |> put_status(:created)
        |> put_view(AccountView)
        |> render("show.json", account: account)
    end
  end

  def show(conn, %{"account_number" => account_number}) do
    case Account.validate_account_exists(account_number) do
      {:ok, account} ->
        conn
        |> put_status(:ok)
        |> put_view(AccountView)
        |> render("show.json", account: account)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(BankDigitalApiWeb.ErrorView)
        |> render("404.json")
    end
  end

  def show(conn, _args),
    do:
      conn
      |> put_status(:not_found)
      |> put_view(BankDigitalApiWeb.ErrorView)
      |> render("404.json")
end
