defmodule BankDigitalApi.Service.Transaction do
  @moduledoc """
    O service é responsavél para controlar a logica e querys referente as transações
  """
  import Ecto.Query, warn: false
  alias BankDigitalApi.Repo
  alias BankDigitalApi.Schemas.Transaction

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
    Atualiza uma transação
  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
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
end
