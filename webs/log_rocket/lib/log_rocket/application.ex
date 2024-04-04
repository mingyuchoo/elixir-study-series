defmodule LogRocket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LogRocketWeb.Telemetry,
      LogRocket.Repo,
      {DNSCluster, query: Application.get_env(:log_rocket, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LogRocket.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LogRocket.Finch},
      # Start a worker by calling: LogRocket.Worker.start_link(arg)
      # {LogRocket.Worker, arg},
      # Start to serve requests, typically the last entry
      LogRocketWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LogRocket.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LogRocketWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
