defmodule BankDigitalApiWeb.AccountController do
  use BankDigitalApiWeb, :controller

  alias BankDigitalApi.Schema.Account
  alias BankDigitalApi.Repo

  action_fallback BankDigitalApiWeb.FallbackController

  def create(conn, %{"account_number" => account_number, "balance" => balance}) do
    changeset = Account.changeset(%Account{}, %{"account_number" => account_number, "balance" => balance})

    case Repo.insert(changeset) do
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
  end


  def show(conn, _args) do
    conn
  end
end
