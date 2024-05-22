defmodule BankDigitalApi.Schemas.Account do
  @moduledoc """
    schema da tabela de account
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields_required ~w(balance account_number)a
  @primary_key {:account_number, :integer, autogenerate: false}

  schema "account" do
    field :balance, :decimal

    has_one :transaction, BankDigitalApi.Schemas.Transaction

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, @fields_required)
    |> validate_required(@fields_required)
    |> unique_constraint(:account_number, name: "account_pkey")
  end
end
