defmodule BankDigitalApiWeb.TransactionView do
  use BankDigitalApiWeb, :view

  def render("show.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      account_number: transaction.account_number,
      payment_method: transaction.payment_method,
      amount: transaction.amount,
      balance_after_transaction: transaction.balance_after_transaction,
      inserted_at: transaction.inserted_at
    }
  end

  def render("error.json", %{message: message}) do
    %{
      error: message
    }
  end
end
