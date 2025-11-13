defmodule RepoMonitor.MixProject do
  use Mix.Project

  def project do
    [
      app: :repo_monitor,
      version: "0.1.0",
      elixir: "~> 1.19",
      otp_app: true,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {RepoMonitor.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:file_system, "~> 1.0"}
    ]
  end
end
