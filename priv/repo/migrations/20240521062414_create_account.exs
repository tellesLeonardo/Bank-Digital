defmodule BankDigitalApi.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:account, primary_key: false) do
      add :numero_conta, :integer, primary_key: true
      add :saldo, :decimal, precision: 10, scale: 2, null: false

      timestamps()
    end
  end
end
