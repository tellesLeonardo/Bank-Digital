defmodule BankDigitalApiWeb.FallbackController do
  use BankDigitalApiWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BankDigitalApiWeb.ErrorView)
    |> render("404.json")
  end

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BankDigitalApiWeb.ErrorView)
    |> render("400.json")
  end

  def call(conn, {:error, :unprocessable_entity, changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankDigitalApiWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end
end
