defmodule BankDigitalApiWeb.TransactionControllerTest do
  use BankDigitalApiWeb.ConnCase, async: true

  import BankDigitalApi.Factory

  alias BankDigitalApi.Service.Account

  @account_number 12345
  @create_credito_attrs %{account_number: @account_number, payment_method: "C", amount: "100.00"}
  @create_debito_attrs %{account_number: @account_number, payment_method: "D", amount: "100.00"}
  @create_pix_attrs %{account_number: @account_number, payment_method: "P", amount: "100.00"}
  @invalid_payment_method_attrs %{
    account_number: @account_number,
    payment_method: "X",
    amount: "100.00"
  }
  @insufficient_funds_attrs %{
    account_number: @account_number,
    payment_method: "C",
    amount: "10000.00"
  }
  @invalid_attrs %{account_number: nil, payment_method: nil, amount: nil}

  describe "create transaction" do
    setup do
      account = insert(:account, account_number: @account_number, balance: Decimal.new("1000.00"))
      {:ok, account: account}
    end

    test "renders transaction when data is valid payment_method C", %{conn: conn} do
      conn = post(conn, ~p"/transacao", @create_credito_attrs)

      assert %{
               "numero_conta" => @account_number,
               "forma_pagamento" => "C",
               "valor" => "100.00",
               "message" => "efetuada a transação"
             } = json_response(conn, 201)

      assert {:ok, account} = Account.validate_account_exists(@account_number)
      assert account.balance == Decimal.new("895.00")
    end

    test "renders transaction when data is valid payment_method D", %{conn: conn} do
      conn = post(conn, ~p"/transacao", @create_debito_attrs)

      assert %{
               "numero_conta" => @account_number,
               "forma_pagamento" => "D",
               "valor" => "100.00",
               "message" => "efetuada a transação"
             } = json_response(conn, 201)

      assert {:ok, account} = Account.validate_account_exists(@account_number)
      assert account.balance == Decimal.new("897.00")
    end

    test "renders transaction when data is valid payment_method P", %{conn: conn} do
      conn = post(conn, ~p"/transacao", @create_pix_attrs)

      assert %{
               "numero_conta" => @account_number,
               "forma_pagamento" => "P",
               "valor" => "100.00",
               "message" => "efetuada a transação"
             } = json_response(conn, 201)

      assert {:ok, account} = Account.validate_account_exists(@account_number)
      assert account.balance == Decimal.new("900.00")
    end

    test "renders 404 when account does not exist", %{conn: conn} do
      conn = post(conn, ~p"/transacao", Map.put(@create_credito_attrs, :account_number, 99999))
      assert json_response(conn, 404)["errors"] != %{}
    end

    test "renders error when payment method is invalid", %{conn: conn} do
      conn = post(conn, ~p"/transacao", @invalid_payment_method_attrs)
      assert %{"error" => "forma de pagamento inválida"} = json_response(conn, 404)
    end

    test "renders error when insufficient funds", %{conn: conn} do
      conn = post(conn, ~p"/transacao", @insufficient_funds_attrs)
      assert %{"error" => "saldo insuficiente"} = json_response(conn, 404)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/transacao", @invalid_attrs)
      assert json_response(conn, 404)["errors"] != %{}
    end
  end
end
