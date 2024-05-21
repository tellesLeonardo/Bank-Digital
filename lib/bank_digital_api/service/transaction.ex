defmodule BankDigitalApi.Service.Transaction do
  @moduledoc """
    O service é responsavél para controlar a logica e querys referente as transações
  """
  import Ecto.Query, warn: false
  alias BankDigitalApi.Repo
  alias BankDigitalApi.Schemas.{Account, Transaction}

  @doc """
  Retorna todas as transações
  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
    Retorna uma transação pelo ID
  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
    Cria uma nova transação
  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Deleta uma transação
  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
    Retorna uma changeset para rastreamento de mudanças
  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end


  @doc """
    Retorna um tupla informando quanto é o valor de amount com taxa
  """
  def validate_sufficient_funds(%Account{} = account, amount, payment_method) do
    with {:ok, total_amount} <- calculate_total_amount(amount, payment_method),
    :ok <- ensure_sufficient_funds(account, total_amount) do
      {:ok, total_amount}
    else
      {:error, _} = error -> error
    end
  end

  defp calculate_total_amount(amount, payment_method) do
    case Transaction.get_tax(payment_method) do
      :invalid_tax -> {:error, :invalid_payment_method}
      tax ->
        total_amount = amount + (amount * tax)
        {:ok, total_amount}
    end
  end

  defp ensure_sufficient_funds(%Account{balance: balance}, total_amount) do
    if total_amount <= balance, do: :ok, else: {:error, :insufficient_funds}
  end
end
