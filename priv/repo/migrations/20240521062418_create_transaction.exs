defmodule BankDigitalApi.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transaction) do
      add :account_number, references(:account, column: :account_number, type: :integer, on_delete: :nothing), null: false
      add :payment_method, :string, size: 1, null: false
      add :amount, :decimal, precision: 10, scale: 2, null: false
      add :timestamp, :naive_datetime, null: false, default: fragment("now()")

      timestamps()
    end

    create index(:transaction, [:account_number])
  end
end
