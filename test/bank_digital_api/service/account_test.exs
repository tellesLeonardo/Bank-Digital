defmodule BankDigitalApi.Service.AccountTest do
  use BankDigitalApi.DataCase, async: true

  import BankDigitalApi.Factory

  alias BankDigitalApi.Service.Account
  alias BankDigitalApi.Schemas.Account, as: AccountSchema

  @valid_attrs %{numero_conta: 1, saldo: Decimal.new("1000.00")}
  @update_attrs %{saldo: Decimal.new("2000.00")}
  @invalid_attrs %{numero_conta: nil, saldo: nil}

  describe "list_accounts/0" do
    test "returns all accounts" do
      account = insert(:account)
      assert Account.list_accounts() == [account]
    end

    test "returns zero accounts" do
      assert Account.list_accounts() == []
    end
  end

  describe "validate_account_exists/1" do
    test "returns the account with given id" do
      account = insert(:account)
      assert Account.validate_account_exists(account.numero_conta) == {:ok, account}
    end

    test "search for an account that does not exist" do
      assert {:error, :not_found} == Account.validate_account_exists(123_456)
    end
  end

  describe "create_account/1" do
    test "creates an account with valid data" do
      assert {:ok, %AccountSchema{} = account} = Account.create_account(@valid_attrs)
      assert account.numero_conta == 1
      assert account.saldo == Decimal.new("1000.00")
    end

    test "does not create account and returns error changeset with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Account.create_account(@invalid_attrs)
    end

    test "fails to create account with duplicate numero_conta" do
      {:ok, %AccountSchema{} = _account} = Account.create_account(@valid_attrs)
      {:error, changeset} = Account.create_account(@valid_attrs)

      assert changeset.errors[:numero_conta] ==
               {"has already been taken",
                [{:constraint, :unique}, {:constraint_name, "account_pkey"}]}
    end
  end

  describe "update_account/2" do
    test "updates the account with valid data" do
      account = insert(:account)
      assert {:ok, %AccountSchema{} = account} = Account.update_account(account, @update_attrs)
      assert account.saldo == Decimal.new("2000.00")
    end

    test "does not update account and returns error changeset with invalid data" do
      account = insert(:account)
      assert {:error, %Ecto.Changeset{}} = Account.update_account(account, @invalid_attrs)
      assert {:ok, account} == Account.validate_account_exists(account.numero_conta)
    end
  end

  describe "delete_account/1" do
    test "deletes the account" do
      account = insert(:account)
      assert {:ok, %AccountSchema{}} = Account.delete_account(account)
      assert {:error, :not_found} == Account.validate_account_exists(account.numero_conta)
    end
  end

  describe "change_account/1" do
    test "returns a changeset for tracking changes" do
      account = insert(:account)
      assert %Ecto.Changeset{} = Account.change_account(account)
    end
  end
end
