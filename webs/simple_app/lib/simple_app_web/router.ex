defmodule SimpleAppWeb.Router do
  use SimpleAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SimpleAppWeb do
    pipe_through :api

    get "/", PageController, :index
  end
end
