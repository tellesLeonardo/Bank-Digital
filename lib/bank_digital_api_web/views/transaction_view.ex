defmodule BankDigitalApiWeb.TransactionView do
  use BankDigitalApiWeb, :view

  def render("show.json", %{transaction: transaction}) do
    %{
      numero_conta: transaction.account_number,
      forma_pagamento: transaction.payment_method,
      valor: transaction.amount,
      message: "efetuada a transação",
      inserido_em: transaction.inserted_at
    }
  end

  def render("error.json", %{message: message}) do
    %{
      error: message
    }
  end
end
