defmodule BankDigitalApi.Schemas.AccountTest do
  use BankDigitalApi.DataCase, async: true

  alias BankDigitalApi.Schemas.Account

  @valid_attrs %{account_number: 1, balance: 1000.00}
  @invalid_attrs %{account_number: nil, balance: nil}

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

    assert %{account_number: ["can't be blank"], balance: ["can't be blank"]} =
             errors_on(changeset)
  end
end
