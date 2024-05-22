defmodule BankDigitalApi.Schemas.TransactionTest do
  use BankDigitalApi.DataCase, async: true

  import BankDigitalApi.Factory
  alias BankDigitalApi.Schemas.Transaction

  @valid_attrs %{numero_conta: nil, forma_pagamento: "C", valor: 100.00}
  @invalid_attrs %{numero_conta: nil, forma_pagamento: nil, valor: nil}

  setup do
    account = insert(:account)

    valid_attrs =
      Map.put(@valid_attrs, :numero_conta, account.numero_conta)

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
             numero_conta: ["can't be blank"],
             forma_pagamento: ["can't be blank"],
             valor: ["can't be blank"]
           } = errors_on(changeset)
  end

  test "validates forma_pagamento inclusion" do
    changeset = Transaction.changeset(%Transaction{}, %{forma_pagamento: "X"})
    assert %{forma_pagamento: ["is invalid"]} = errors_on(changeset)
  end
end
