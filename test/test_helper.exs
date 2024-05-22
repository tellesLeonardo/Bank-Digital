ExUnit.start(capture_log: true)
Ecto.Adapters.SQL.Sandbox.mode(BankDigitalApi.Repo, :manual)
Ecto.Adapters.SQL.Sandbox.checkout(BankDigitalApi.Repo)

{:ok, _} = Application.ensure_all_started(:ex_machina)
