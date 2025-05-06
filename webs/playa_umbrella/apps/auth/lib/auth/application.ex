defmodule Auth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Auth.Repo,
      {DNSCluster, query: Application.get_env(:auth, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Auth.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Auth.Finch}
      # Start a worker by calling: Auth.Worker.start_link(arg)
      # {Auth.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Auth.Supervisor)
  end
end
