defmodule RepoMonitor.GitFetcher do
  use GenServer
  require Logger

  @fetch_interval 5000 # 5 seconds in milliseconds

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
    
    # Use try/rescue for better error handling in OTP 27
    try do
      case System.cmd("git", ["pull"], cd: repo_path) do
        {result, 0} ->
          Logger.info("Git fetch succeeded: #{result}")
        {result, exit_code} ->
          Logger.error("Git fetch failed with exit code #{exit_code}: #{result}")
      end
    rescue
      e ->
        Logger.error("Error executing git pull: #{Exception.message(e)}")
    end
  end
end
