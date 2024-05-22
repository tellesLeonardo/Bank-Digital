defmodule BankDigitalApi.Service.TransactionTest do
  use BankDigitalApi.DataCase, async: true

  import BankDigitalApi.Factory

  alias BankDigitalApi.Service.Transaction
  alias BankDigitalApi.Schemas.Transaction, as: TransactionSchema

  @valid_attrs %{payment_method: "C", amount: Decimal.new("100.00")}
  @invalid_attrs %{payment_method: nil, amount: nil}

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
      attrs = Map.put(@valid_attrs, :account_number, account.account_number)

      assert account.balance == Decimal.new("1000.00")

      assert {:ok, %TransactionSchema{} = transaction} =
               Transaction.create_transaction(account, attrs)

      assert transaction.account_number == account.account_number
      assert transaction.payment_method == "C"
      assert transaction.amount == Decimal.new("100.00")
      assert transaction.account.balance == Decimal.new("895.00")
    end

    test "create a transaction with valid data being a debit transaction", %{account: account} do
      attrs = %{
        payment_method: "D",
        amount: Decimal.new("100.00"),
        account_number: account.account_number
      }

      assert account.balance == Decimal.new("1000.00")

      assert {:ok, %TransactionSchema{} = transaction} =
               Transaction.create_transaction(account, attrs)

      assert transaction.account_number == account.account_number
      assert transaction.payment_method == "D"
      assert transaction.amount == Decimal.new("100.00")
      assert transaction.account.balance == Decimal.new("897.00")
    end

    test "create a transaction with valid data being a transaction per pix", %{account: account} do
      attrs = %{
        payment_method: "P",
        amount: Decimal.new("100.00"),
        account_number: account.account_number
      }

      assert account.balance == Decimal.new("1000.00")

      assert {:ok, %TransactionSchema{} = transaction} =
               Transaction.create_transaction(account, attrs)

      assert transaction.account_number == account.account_number
      assert transaction.payment_method == "P"
      assert transaction.amount == Decimal.new("100.00")
      assert transaction.account.balance == Decimal.new("900.00")
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
      invalid_attrs = %{payment_method: "X", amount: Decimal.new("100.00")}

      assert {:error, :invalid_payment_method} =
               Transaction.create_transaction(account, invalid_attrs)
    end

    test "does not create transaction and returns error with insufficient balance", %{
      account: account
    } do
      invalid_attrs = %{payment_method: "P", amount: Decimal.new("2000.00")}

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
      assert {:ok, _total_amount} =
               Transaction.validate_sufficient_funds(account, %{
                 amount: Decimal.new("100.00"),
                 payment_method: "C"
               })
    end

    test "returns :error when there are insufficient funds", %{account: account} do
      assert {:error, :insufficient_funds} =
               Transaction.validate_sufficient_funds(account, %{
                 amount: Decimal.new("10000.00"),
                 payment_method: "C"
               })
    end
  end
end
