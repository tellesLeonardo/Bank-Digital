defmodule BankDigitalApi.Schemas.Account do
  @moduledoc """
    schema da tabela de account
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields_required ~w(saldo numero_conta)a
  @primary_key {:numero_conta, :integer, autogenerate: false}

  schema "account" do
    field :saldo, :decimal

    has_one :transaction, BankDigitalApi.Schemas.Transaction

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, @fields_required)
    |> validate_required(@fields_required)
    |> unique_constraint(:numero_conta, name: "account_pkey")
  end
end
