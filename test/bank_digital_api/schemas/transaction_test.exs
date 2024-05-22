defmodule BankDigitalApi.Schemas.TransactionTest do
  use BankDigitalApi.DataCase, async: true

  import BankDigitalApi.Factory
  alias BankDigitalApi.Schemas.Transaction

  @valid_attrs %{account_number: nil, payment_method: "C", amount: 100.00}
  @invalid_attrs %{account_number: nil, payment_method: nil, amount: nil}

  setup do
    account = insert(:account)

    valid_attrs =
      Map.put(@valid_attrs, :account_number, account.account_number)

    {:ok, account: account, valid_attrs: valid_attrs}
  end

  test "changeset with valid attributes", %{valid_attrs: valid_attrs} do
    changeset = Transaction.changeset(%Transaction{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "validates required fields" do
    changeset = Transaction.changeset(%Transaction{}, %{})

    assert %{
             account_number: ["can't be blank"],
             payment_method: ["can't be blank"],
             amount: ["can't be blank"]
           } = errors_on(changeset)
  end

  test "validates payment_method inclusion" do
    changeset = Transaction.changeset(%Transaction{}, %{payment_method: "X"})
    assert %{payment_method: ["is invalid"]} = errors_on(changeset)
  end
end
