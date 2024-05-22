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

  @required_fields ~w(numero_conta forma_pagamento valor)a
  @optional_fields ~w(timestamp)a
  @payment_methods ~w(C D P)
  @payment_method_taxes %{"C" => :tax_credito, "D" => :tax_debito, "P" => :tax_pix}

  schema "transaction" do
    field :forma_pagamento, :string
    field :valor, :decimal
    field :timestamp, :naive_datetime

    belongs_to :account, BankDigitalApi.Schemas.Account,
      foreign_key: :numero_conta,
      references: :numero_conta

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:forma_pagamento, max: 1, message: message_error_forma_pagamentos())
    |> validate_inclusion(:forma_pagamento, @payment_methods)
    |> foreign_key_constraint(:numero_conta)
  end

  defp message_error_forma_pagamentos,
    do: "Invalid payment method will only be accepted: #{Enum.join(@payment_methods, ", ")}"

  @doc """
    Retorna a taxa de acordo com o método de pagamento.
  """
  def get_tax(forma_pagamento) when forma_pagamento in @payment_methods do
    tax_atom = Map.get(@payment_method_taxes, forma_pagamento)

    Application.get_env(:bank_digital_api, tax_atom)
  end

  def get_tax(_forma_pagamento), do: :invalid_tax
end
