defmodule BankDigitalApiWeb.AccountControllerTest do
  use BankDigitalApiWeb.ConnCase, async: true

  import BankDigitalApi.Factory

  alias BankDigitalApi.Service.Account

  @create_attrs %{numero_conta: 12345, saldo: "1000.00"}
  @invalid_attrs %{numero_conta: nil, saldo: nil}

  describe "create account" do
    test "renders account when data is valid and account does not exist", %{conn: conn} do
      conn = post(conn, ~p"/conta", @create_attrs)

      return = json_response(conn, 201)

      assert %{"numero_conta" => 12345, "saldo" => "1000.00"} = return

      assert {:ok, _account} = Account.validate_account_exists(return["numero_conta"])
    end

    test "renders account when account already exists", %{conn: conn} do
      insert(:account, numero_conta: 12345, saldo: "1000.00")
      conn = post(conn, ~p"/conta", @create_attrs)
      assert %{"numero_conta" => 12345, "saldo" => "1000.00"} = json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/conta", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show account" do
    test "renders account", %{conn: conn} do
      account = insert(:account, numero_conta: 12345, saldo: "1000.00")

      conn = get(conn, ~p"/conta?numero_conta=#{account.numero_conta}")

      assert %{"numero_conta" => 12345, "saldo" => "1000.00"} = json_response(conn, 200)
    end

    test "no account", %{conn: conn} do
      insert(:account, numero_conta: 12345, saldo: "1000.00")

      conn = get(conn, ~p"/conta")

      assert %{"error" => "Not Found"} == json_response(conn, 404)
    end

    test "renders 404 when account does not exist", %{conn: conn} do
      conn = get(conn, ~p"/conta?numero_conta=96287")

      assert %{"error" => "Not Found"} == json_response(conn, 404)
    end
  end
end
