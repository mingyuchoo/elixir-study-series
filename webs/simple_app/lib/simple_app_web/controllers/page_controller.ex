defmodule SimpleAppWeb.PageController do
  use SimpleAppWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{message: "Welcome to SimpleAppWeb API!"})
  end
end
