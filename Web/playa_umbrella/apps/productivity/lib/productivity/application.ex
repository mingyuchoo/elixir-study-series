defmodule Productivity.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Productivity.Repo,
      {DNSCluster, query: Application.get_env(:productivity, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Productivity.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Productivity.Finch}
      # Start a worker by calling: Productivity.Worker.start_link(arg)
      # {Productivity.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Productivity.Supervisor)
  end
end
