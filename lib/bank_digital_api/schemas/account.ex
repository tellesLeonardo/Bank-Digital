defmodule BankDigitalApi.Schemas.Account do
  @moduledoc """
    schema da tabela de account
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields_required ~w(account_number balance)a

  schema "account" do
    field :account_number, :integer, primary_key: true
    field :balance, :decimal

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, @fields_required)
    |> validate_required(@fields_required)
    |> unique_constraint(:account_number)
  end
end
