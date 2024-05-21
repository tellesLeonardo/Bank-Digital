defmodule BankDigitalApi.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:account, primary_key: false) do
      add :account_number, :integer, primary_key: true
      add :balance, :decimal, precision: 10, scale: 2, null: false

      timestamps()
    end
  end
end
