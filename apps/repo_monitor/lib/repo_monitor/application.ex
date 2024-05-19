defmodule RepoMonitor.Application do
  use Application

  @impl true
  def start(_type, _args) do
    repo_path = Application.get_env(:repo_monitor, :repo_path)
    build_command = Application.get_env(:repo_monitor, :build_command)
    children = [
      {RepoMonitor.GitBuilder, {repo_path, build_command}},
      {RepoMonitor.GitFetcher, repo_path}
    ]
    opts = [strategy: :one_for_one, name: RepoMonitor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
