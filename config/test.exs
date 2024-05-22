import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :bank_digital_api, BankDigitalApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("HOST", "localhost"),
  port: System.get_env("PORT", "5432"),
  database: "bank_digital_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bank_digital_api, BankDigitalApiWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4002],
  secret_key_base: "wusKCLwsMvloaKVLcaoZA0zlwTXDNdayQ3ZyslN/or+k/5sk163MSlgIv5Vorh6k",
  server: false

# In test we don't send emails.
config :bank_digital_api, BankDigitalApi.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
