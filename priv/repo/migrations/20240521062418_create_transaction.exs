defmodule BankDigitalApi.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transaction) do
      add :numero_conta, references(:account, column: :numero_conta, type: :integer, on_delete: :nothing), null: false
      add :forma_pagamento, :string, size: 1, null: false
      add :valor, :decimal, precision: 10, scale: 2, null: false
      add :timestamp, :naive_datetime, null: false, default: fragment("now()")

      timestamps()
    end

    create index(:transaction, [:numero_conta])
  end
end
