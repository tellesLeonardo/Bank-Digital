defmodule BankDigitalApiWeb.TransactionControllerTest do
  use BankDigitalApiWeb.ConnCase, async: true

  import BankDigitalApi.Factory

  alias BankDigitalApi.Service.Account

  @numero_conta 12345
  @create_credito_attrs %{numero_conta: @numero_conta, forma_pagamento: "C", valor: "100.00"}
  @create_debito_attrs %{numero_conta: @numero_conta, forma_pagamento: "D", valor: "100.00"}
  @create_pix_attrs %{numero_conta: @numero_conta, forma_pagamento: "P", valor: "100.00"}
  @invalid_payment_method_attrs %{
    numero_conta: @numero_conta,
    forma_pagamento: "X",
    valor: "100.00"
  }
  @insufficient_funds_attrs %{
    numero_conta: @numero_conta,
    forma_pagamento: "C",
    valor: "10000.00"
  }
  @invalid_attrs %{numero_conta: nil, forma_pagamento: nil, valor: nil}

  describe "create transaction" do
    setup do
      account = insert(:account, numero_conta: @numero_conta, saldo: Decimal.new("1000.00"))
      {:ok, account: account}
    end

    test "renders transaction when data is valid forma_pagamento C", %{conn: conn} do
      conn = post(conn, ~p"/transacao", @create_credito_attrs)

      assert %{
               "numero_conta" => @numero_conta,
               "forma_pagamento" => "C",
               "valor" => "100.00",
               "message" => "efetuada a transação"
             } = json_response(conn, 201)

      assert {:ok, account} = Account.validate_account_exists(@numero_conta)
      assert account.saldo == Decimal.new("895.00")
    end

    test "renders transaction when data is valid forma_pagamento D", %{conn: conn} do
      conn = post(conn, ~p"/transacao", @create_debito_attrs)

      assert %{
               "numero_conta" => @numero_conta,
               "forma_pagamento" => "D",
               "valor" => "100.00",
               "message" => "efetuada a transação"
             } = json_response(conn, 201)

      assert {:ok, account} = Account.validate_account_exists(@numero_conta)
      assert account.saldo == Decimal.new("897.00")
    end

    test "renders transaction when data is valid forma_pagamento P", %{conn: conn} do
      conn = post(conn, ~p"/transacao", @create_pix_attrs)

      assert %{
               "numero_conta" => @numero_conta,
               "forma_pagamento" => "P",
               "valor" => "100.00",
               "message" => "efetuada a transação"
             } = json_response(conn, 201)

      assert {:ok, account} = Account.validate_account_exists(@numero_conta)
      assert account.saldo == Decimal.new("900.00")
    end

    test "renders 404 when account does not exist", %{conn: conn} do
      conn = post(conn, ~p"/transacao", Map.put(@create_credito_attrs, :numero_conta, 99999))
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
