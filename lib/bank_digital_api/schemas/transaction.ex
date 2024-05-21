defmodule BankDigitalApi.Schema.Transaction do
  @moduledoc """
    schema da tabela de trasação
    Os metodo de pagamento são C de Crédito, D de Débito, B de Boleto
  """

  use Ecto.Schema
  import Ecto.Changeset

  @fields_required ~w(account_number payment_method amount)a
  @fields ~w(timestamp)a
  @payment_methods ~w(C D B)

  schema "transaction" do
    field :account_number, :integer
    field :payment_method, :string
    field :amount, :decimal
    field :timestamp, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @fields_required ++ @fields)
    |> validate_required(@fields_required)
    |> validate_length(:payment_method, max: 1, message: message_error_payment_methods())
    |> validate_inclusion(:payment_method, @payment_methods)
    |> foreign_key_constraint(:account_number)
  end

  defp message_error_payment_methods, do:
    "Invalid payment method will only be accepted: #{Enum.join(@payment_methods, ", ")}"
end
