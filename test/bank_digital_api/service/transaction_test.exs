defmodule BankDigitalApi.Service.TransactionTest do
  use BankDigitalApi.DataCase, async: true

  import BankDigitalApi.Factory

  alias BankDigitalApi.Service.Transaction
  alias BankDigitalApi.Schemas.Transaction, as: TransactionSchema

  @valid_attrs %{forma_pagamento: "C", valor: Decimal.new("100.00")}
  @invalid_attrs %{forma_pagamento: nil, valor: nil}

  setup do
    account = insert(:account)
    {:ok, account: account}
  end

  describe "list_transactions/0" do
    test "returns all transactions" do
      transaction = insert(:transaction)
      assert Transaction.list_transactions() == [transaction]
    end

    test "returns zero transactions" do
      assert Transaction.list_transactions() == []
    end
  end

  describe "get_transaction/1" do
    test "returns the transaction with given id" do
      transaction = insert(:transaction)
      assert Transaction.get_transaction(transaction.id) == {:ok, transaction}
    end

    test "raises Ecto.NoResultsError if transaction does not exist" do
      assert {:error, :not_found} == Transaction.get_transaction(123_456)
    end
  end

  describe "create_transaction/2" do
    test "create a transaction with valid data being a credit transaction", %{account: account} do
      attrs = Map.put(@valid_attrs, :numero_conta, account.numero_conta)

      assert account.saldo == Decimal.new("1000.00")

      assert {:ok, %TransactionSchema{} = transaction} =
               Transaction.create_transaction(account, attrs)

      assert transaction.numero_conta == account.numero_conta
      assert transaction.forma_pagamento == "C"
      assert transaction.valor == Decimal.new("100.00")
      assert transaction.account.saldo == Decimal.new("895.00")
    end

    test "create a transaction with valid data being a debit transaction", %{account: account} do
      attrs = %{
        forma_pagamento: "D",
        valor: Decimal.new("100.00"),
        numero_conta: account.numero_conta
      }

      assert account.saldo == Decimal.new("1000.00")

      assert {:ok, %TransactionSchema{} = transaction} =
               Transaction.create_transaction(account, attrs)

      assert transaction.numero_conta == account.numero_conta
      assert transaction.forma_pagamento == "D"
      assert transaction.valor == Decimal.new("100.00")
      assert transaction.account.saldo == Decimal.new("897.00")
    end

    test "create a transaction with valid data being a transaction per pix", %{account: account} do
      attrs = %{
        forma_pagamento: "P",
        valor: Decimal.new("100.00"),
        numero_conta: account.numero_conta
      }

      assert account.saldo == Decimal.new("1000.00")

      assert {:ok, %TransactionSchema{} = transaction} =
               Transaction.create_transaction(account, attrs)

      assert transaction.numero_conta == account.numero_conta
      assert transaction.forma_pagamento == "P"
      assert transaction.valor == Decimal.new("100.00")
      assert transaction.account.saldo == Decimal.new("900.00")
    end

    test "does not create transaction and returns error changeset with invalid data", %{
      account: account
    } do
      assert {:error, :invalid_payment_method} =
               Transaction.create_transaction(account, @invalid_attrs)
    end

    test "does not create transaction and returns error with invalid payment method", %{
      account: account
    } do
      invalid_attrs = %{forma_pagamento: "X", valor: Decimal.new("100.00")}

      assert {:error, :invalid_payment_method} =
               Transaction.create_transaction(account, invalid_attrs)
    end

    test "does not create transaction and returns error with insufficient saldo", %{
      account: account
    } do
      invalid_attrs = %{forma_pagamento: "P", valor: Decimal.new("2000.00")}

      assert {:error, :insufficient_funds} =
               Transaction.create_transaction(account, invalid_attrs)
    end
  end

  describe "delete_transaction/1" do
    test "deletes the transaction" do
      transaction = insert(:transaction)
      assert {:ok, %TransactionSchema{}} = Transaction.delete_transaction(transaction)
      assert {:error, :not_found} == Transaction.get_transaction(transaction.id)
    end

    test "returns error if transaction does not exist" do
      assert {:error, :not_found} ==
               Transaction.delete_transaction(%TransactionSchema{id: 85_274_196})
    end
  end

  describe "change_transaction/1" do
    test "returns a changeset for tracking changes" do
      transaction = insert(:transaction)
      assert %Ecto.Changeset{} = Transaction.change_transaction(transaction)
    end
  end

  describe "validate_sufficient_funds/3" do
    test "returns :ok when there are sufficient funds", %{account: account} do
      assert {:ok, _total_valor} =
               Transaction.validate_sufficient_funds(account, %{
                 valor: Decimal.new("100.00"),
                 forma_pagamento: "C"
               })
    end

    test "returns :error when there are insufficient funds", %{account: account} do
      assert {:error, :insufficient_funds} =
               Transaction.validate_sufficient_funds(account, %{
                 valor: Decimal.new("10000.00"),
                 forma_pagamento: "C"
               })
    end
  end
end
