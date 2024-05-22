defmodule BankDigitalApi.Schemas.AccountTest do
  use BankDigitalApi.DataCase, async: true

  alias BankDigitalApi.Schemas.Account

  @valid_attrs %{numero_conta: 1, saldo: 1000.00}
  @invalid_attrs %{numero_conta: nil, saldo: nil}

  test "changeset with valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "validates required fields" do
    changeset = Account.changeset(%Account{}, %{})

    assert %{numero_conta: ["can't be blank"], saldo: ["can't be blank"]} =
             errors_on(changeset)
  end
end
