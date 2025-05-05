defmodule ExampleApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :example_app,
      version: "0.1.0",
      elixir: "~> 1.17",
      escript: escript()
    ]
  end

  defp escript do
    [main_module: ExampleApp.CLI]
  end
end
