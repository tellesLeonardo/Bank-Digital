defmodule BankDigitalApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BankDigitalApiWeb.Telemetry,
      BankDigitalApi.Repo,
      {DNSCluster, query: Application.get_env(:bank_digital_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BankDigitalApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BankDigitalApi.Finch},
      # Start a worker by calling: BankDigitalApi.Worker.start_link(arg)
      # {BankDigitalApi.Worker, arg},
      # Start to serve requests, typically the last entry
      BankDigitalApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BankDigitalApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BankDigitalApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
