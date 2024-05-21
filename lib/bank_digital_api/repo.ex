defmodule BankDigitalApi.Repo do
  use Ecto.Repo,
    otp_app: :bank_digital_api,
    adapter: Ecto.Adapters.Postgres
end
