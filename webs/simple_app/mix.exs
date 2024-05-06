defmodule SimpleApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_app,
      version: "0.1.0",
      elixir: "~> 1.16",
      elixirc_paths: [
        "lib"
      ],
      start_permanent: Mix.env() == :prod,
      deps: [
        {:phoenix, "~> 1.7.12"},
        {:jason, "~> 1.2"},
        {:bandit, "~> 1.2"}
      ]
    ]
  end

  def application do
    [
      mod: {SimpleApp.Application, []},
    ]
  end

end
