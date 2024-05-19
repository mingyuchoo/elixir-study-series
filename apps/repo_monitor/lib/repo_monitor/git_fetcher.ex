defmodule RepoMonitor.GitFetcher do
  use GenServer
  require Logger

  @fetch_interval :timer.seconds(5)

  def start_link(repo_path) do
    GenServer.start_link(__MODULE__, repo_path, name: __MODULE__)
  end

  @impl true
  def init(repo_path) do
    Logger.info("GitFetcher initialized")
    schedule_fetch()
    {:ok, %{repo_path: repo_path}}
  end

  @impl true
  def handle_info(:fetch, state) do
    Logger.info(":fetch message received")
    run_fetch(state.repo_path)
    schedule_fetch()
    {:noreply, state}
  end

  defp schedule_fetch do
    Logger.info("Scheduling next fetch in #{@fetch_interval} milliseconds")
    Process.send_after(self(), :fetch, @fetch_interval)
  end

  defp run_fetch(repo_path) do
    Logger.info("Running git fetch in #{repo_path}")
    {result, exit_code} = System.cmd("git", ["pull"], cd: repo_path)
    if exit_code == 0 do
      Logger.info("Git fetch succeeded: #{result}")
    else
      Logger.error("Git fetch failed with exit code #{exit_code}: #{result}")
    end
  end
end
