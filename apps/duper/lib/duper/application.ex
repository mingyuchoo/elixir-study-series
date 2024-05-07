defmodule Duper.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Duper.ResultStorage,
      {Duper.PathFinder, "/home/mgch/Documents/"},
      Duper.WorkerSupervisor,
      {Duper.ResultGatherer, 4}
    ]

    opts = [strategy: :one_for_all, name: Duper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
