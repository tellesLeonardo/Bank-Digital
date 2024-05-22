defmodule BankDigitalApi.Service.Account do
  @moduledoc """
    O service é responsavél para controlar a logica e querys referente as contas
  """
  import Ecto.Query, warn: false
  alias BankDigitalApi.Repo
  alias BankDigitalApi.Schemas.Account

  @doc """
    Retorna todas as contas de usuário
  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
    Retorna uma conta de usuário pelo número da conta
  """
  def validate_account_exists(nil), do: {:error, :not_found}

  def validate_account_exists(account_number) do
    case Repo.get(Account, account_number) do
      nil -> {:error, :not_found}
      %Account{} = account -> {:ok, account}
    end
  end

  @doc """
    Cria uma nova conta de usuário
  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Atualiza uma conta de usuário
  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
    Deleta uma conta de usuário
  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
    Retorna uma changeset para rastreamento de mudanças
  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end
end
