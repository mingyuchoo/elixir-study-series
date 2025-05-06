defmodule Playa.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Playa.Repo,
      {DNSCluster, query: Application.get_env(:playa, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Playa.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Playa.Finch}
      # Start a worker by calling: Playa.Worker.start_link(arg)
      # {Playa.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Playa.Supervisor)
  end
end
