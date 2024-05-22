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

  @fields_required ~w(numero_conta forma_pagamento valor)a
  @fields_optional ~w(timestamp)a
  @forma_pagamentos ~w(C D P)
  @map_tax %{"C" => :tax_credito, "D" => :tax_debito, "P" => :tax_pix}

  schema "transaction" do
    field :forma_pagamento, :string
    field :valor, :decimal
    field :timestamp, :naive_datetime

    belongs_to :account, BankDigitalApi.Schemas.Account, foreign_key: :numero_conta, references: :numero_conta

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
    |> validate_length(:forma_pagamento, max: 1, message: message_error_forma_pagamentos())
    |> validate_inclusion(:forma_pagamento, @forma_pagamentos)
    |> foreign_key_constraint(:numero_conta)
  end

  defp message_error_forma_pagamentos,
    do: "Invalid payment method will only be accepted: #{Enum.join(@forma_pagamentos, ", ")}"

  @doc """
    Retorna a taxa de acordo com o método de pagamento.
  """
  def get_tax(forma_pagamento) when forma_pagamento in @forma_pagamentos do
    atom_tax = Map.get(@map_tax, forma_pagamento)

    Application.get_env(:bank_digital_api, atom_tax)
  end

  def get_tax(_forma_pagamento), do: :invalid_tax
end
