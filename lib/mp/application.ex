defmodule Mp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MpWeb.Telemetry,
      Mp.Repo,
      {DNSCluster, query: Application.get_env(:mp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Mp.Finch},
      # Start a worker by calling: Mp.Worker.start_link(arg)
      # {Mp.Worker, arg},
      # Start to serve requests, typically the last entry
      MpWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
