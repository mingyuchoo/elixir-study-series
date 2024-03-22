defmodule Hello.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster, query: Application.get_env(:hello, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Hello.PubSub}
      # Start a worker by calling: Hello.Worker.start_link(arg)
      # {Hello.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Hello.Supervisor)
  end
end
