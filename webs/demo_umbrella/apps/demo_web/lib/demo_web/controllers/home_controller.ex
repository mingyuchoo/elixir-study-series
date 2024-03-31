defmodule DemoWeb.HomeController do
  use DemoWeb, :controller

  def index(conn, _params) do
    # The index page is often custom made,
    # so skip the default app layout.
    render(conn, :index, layout: false)
  end
end
