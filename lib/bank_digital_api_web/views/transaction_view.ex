defmodule BankDigitalApiWeb.TransactionView do
  use BankDigitalApiWeb, :view

  def render("show.json", %{transaction: transaction}) do
    %{
      numero_conta: transaction.numero_conta,
      forma_pagamento: transaction.forma_pagamento,
      valor: transaction.valor,
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
