defmodule Duper.MixProject do
  use Mix.Project

  def project do
    [
      app: :duper,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {Duper.Application, []}
    ]
  end

  defp deps do
    [
      {:dir_walker, "~> 0.0.8"}
    ]
  end
end
