defmodule BankDigitalApi.Schemas.Account do
  @moduledoc """
    schema da tabela de account
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(saldo numero_conta)a
  @primary_key {:numero_conta, :integer, autogenerate: false}

  schema "account" do
    field :saldo, :decimal

    has_one :transaction, BankDigitalApi.Schemas.Transaction, foreign_key: :numero_conta

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:numero_conta, name: "account_pkey")
  end
end
