defmodule BankDigitalApi.Schemas.Transaction do
  @moduledoc """
    schema da tabela de trasação
    Os metodo de pagamento:
    - C de Crédito
    - D de Débito
    - P de Pix
  """

  use Ecto.Schema
  import Ecto.Changeset

  @fields_required ~w(account_number payment_method amount)a
  @fields_optional ~w(timestamp)a
  @payment_methods ~w(C D P)
  @map_tax %{"C" => :tax_credito, "D" => :tax_debito, "P" => :tax_pix}

  schema "transaction" do
    field :payment_method, :string
    field :amount, :decimal
    field :timestamp, :naive_datetime

    belongs_to :account, BankDigitalApi.Schemas.Account, foreign_key: :account_number

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
    |> validate_length(:payment_method, max: 1, message: message_error_payment_methods())
    |> validate_inclusion(:payment_method, @payment_methods)
    |> foreign_key_constraint(:account_number)
  end

  defp message_error_payment_methods,
    do: "Invalid payment method will only be accepted: #{Enum.join(@payment_methods, ", ")}"

  @doc """
    Retorna a taxa de acordo com o método de pagamento.
  """
  def get_tax(payment_method) when payment_method in @payment_methods do
    atom_tax = Map.get(@map_tax, payment_method)

    Application.get_env(:bank_digital_api, atom_tax)
  end

  def get_tax(_payment_method), do: :invalid_tax
end
