defmodule BankDigitalApi.Service.Transaction do
  @moduledoc """
    O service é responsavél para controlar a logica e querys referente as transações
  """
  import Ecto.Query, warn: false
  alias BankDigitalApi.Repo
  alias BankDigitalApi.Schemas.Transaction
  alias BankDigitalApi.Schemas.Account, as: AccountSchema

  alias BankDigitalApi.Service.Account

  @doc """
  Retorna todas as transações
  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
    Retorna uma transação pelo ID
  """
  def get_transaction(id) do
    case Repo.get(Transaction, id) do
      nil -> {:error, :not_found}
      %Transaction{} = transaction -> {:ok, transaction}
    end
  end

  @doc """
    Deleta uma transação
  """
  def delete_transaction(%Transaction{} = transaction) do
    if transaction.__meta__.state != :built do
      Repo.delete(transaction)
    else
      {:error, :not_found}
    end
  end

  @doc """
    Retorna uma changeset para rastreamento de mudanças
  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  @doc """
    Retorna um tupla informando quanto é o valor de valor com taxa
  """
  def validate_sufficient_funds(%AccountSchema{} = account, attrs) do
    with {:ok, total_valor} <- calculate_total_valor(attrs.valor, attrs.forma_pagamento),
         :ok <- ensure_sufficient_funds(account, total_valor) do
      {:ok, total_valor}
    else
      {:error, _} = error -> error
    end
  end

  @doc """
    Cria uma nova transação
  """

  def create_transaction(%AccountSchema{} = account, attrs) do
    Repo.transaction(fn ->
      with {:ok, total_valor} <- validate_sufficient_funds(account, attrs),
           {:ok, %Transaction{} = transaction} <- create_and_insert_transaction(attrs),
           {:ok, %AccountSchema{} = updated_account} <-
             Account.update_account(account, %{
               saldo: Decimal.sub(account.saldo, total_valor) |> Decimal.round(2)
             }) do
        %{transaction | account: updated_account}
      else
        {:error, error_msg} ->
          Repo.rollback(error_msg)
      end
    end)
  end

  defp create_and_insert_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  defp calculate_total_valor(valor, forma_pagamento) do
    case Transaction.get_tax(forma_pagamento) do
      :invalid_tax ->
        {:error, :invalid_forma_pagamento}

      tax ->
        tax_value = Decimal.mult(valor, Decimal.new(tax))

        total_valor =
          valor
          |> Decimal.add(tax_value)
          |> Decimal.round(2)

        {:ok, total_valor}
    end
  end

  defp ensure_sufficient_funds(%AccountSchema{saldo: saldo}, total_valor) do
    if Decimal.compare(saldo, total_valor) != :lt, do: :ok, else: {:error, :insufficient_funds}
  end
end
