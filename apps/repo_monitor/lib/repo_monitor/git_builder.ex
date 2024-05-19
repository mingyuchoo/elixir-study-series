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
    if Enum.any?(events, fn event -> event in [:created, :modified, :deleted, :renamed] end) and
      not String.starts_with?(path, "#{state.repo_path}/target") and
      not String.starts_with?(path, "#{state.repo_path}/.git") do
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
    {result, exit_code} = System.cmd("sh", ["-c", build_command], cd: repo_path)
    if exit_code == 0 do
      Logger.info("Build succeeded: #{result}")
    else
      Logger.error("Build failed with exit code #{exit_code}: #{result}")
    end
  end
end
