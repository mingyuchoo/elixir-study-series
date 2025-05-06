defmodule PlayaWeb.HomeController do
  use PlayaWeb, :controller

  def index(conn, _params) do
    render(conn, :index, layout: false)
  end

  def components(conn, _params) do
    render(conn, :components)
  end
end
