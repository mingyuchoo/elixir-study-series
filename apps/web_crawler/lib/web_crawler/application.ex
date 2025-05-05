defmodule WebCrawler.Application do
  @moduledoc """
  웹 크롤러 애플리케이션 모듈
  """

  use Application

  @impl true
  def start(_type, _args) do
    args = System.argv()
    WebCrawler.CLI.main(args)
    {:ok, self()}
  end
end
