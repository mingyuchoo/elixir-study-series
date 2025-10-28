defmodule RepoMonitor.GitBuilder do
  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init({repo_path, build_command}) do
    {:ok, pid} = FileSystem.start_link(dirs: [repo_path])
    FileSystem.subscribe(pid)
    {:ok, %{repo_path: repo_path, build_command: build_command, watcher_pid: pid}}
  end

  @impl true
  def handle_info({:file_event, _pid, {path, events}}, state) do
    relevant_events = [:created, :modified, :deleted, :renamed]
    is_relevant_event = Enum.any?(events, &(&1 in relevant_events))
    is_excluded_path = String.starts_with?(path, "#{state.repo_path}/target") or
                      String.starts_with?(path, "#{state.repo_path}/.git")
    
    if is_relevant_event and not is_excluded_path do
      Logger.info("File event [#{Enum.count(events)}] detected: #{path}")
      run_build(state.repo_path, state.build_command)
    end
    
    {:noreply, state}
  end

  @impl true
  def handle_info({:file_event, _pid, :stop}, state) do
    {:noreply, state}
  end

  defp run_build(repo_path, build_command) do
    Logger.info("Running build command in #{repo_path}: #{build_command}")
    
    # Use try/rescue for better error handling in OTP 27
    try do
      case System.cmd("sh", ["-c", build_command], cd: repo_path) do
        {result, 0} ->
          Logger.info("Build succeeded: #{result}")
        {result, exit_code} ->
          Logger.error("Build failed with exit code #{exit_code}: #{result}")
      end
    rescue
      e ->
        Logger.error("Error executing build command: #{Exception.message(e)}")
    end
  end
end
