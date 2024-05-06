defmodule SimpleApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [SimpleAppWeb.Endpoint]
    opts = [strategy: :one_for_one, name: SimpleApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    SimpleAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
