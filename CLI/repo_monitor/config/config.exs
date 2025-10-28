import Config

config :repo_monitor, :repo_path, System.get_env("REPO_PATH") || "."
config :repo_monitor, :build_command, System.get_env("BUILD_COMMAND") || "make build"
