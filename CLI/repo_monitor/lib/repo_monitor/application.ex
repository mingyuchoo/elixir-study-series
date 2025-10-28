defmodule RepoMonitor.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {RepoMonitor.GitBuilder, {repo_path(), build_command()}},
      {RepoMonitor.GitFetcher, repo_path()}
    ]
    opts = [strategy: :one_for_one, name: RepoMonitor.Supervisor]
    Supervisor.start_link(children, opts)
  end
  
  # Helper functions to get configuration - better for runtime config in OTP 27
  defp repo_path, do: Application.fetch_env!(:repo_monitor, :repo_path)
  defp build_command, do: Application.fetch_env!(:repo_monitor, :build_command)
end
