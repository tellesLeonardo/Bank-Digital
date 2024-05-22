defmodule BankDigitalApiWeb.Router do
  use BankDigitalApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BankDigitalApiWeb do
    pipe_through :api

    get "/conta:account_number", AccountController, :show
    post "/conta", AccountController, :create
    post "/transacao", TransactionController, :create
  end
end
