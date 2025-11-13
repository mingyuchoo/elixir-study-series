defmodule WebCrawler.MixProject do
  use Mix.Project

  def project do
    [
      app: :web_crawler,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WebCrawler.Application, []}
    ]
  end

  def escript do
    [
      main_module: WebCrawler.CLI,
      name: "web_crawler"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.32", only: :dev, runtime: false},
      {:httpoison, "~> 2.2.0"},
      {:floki, "~> 0.36.2"}
    ]
  end
end
