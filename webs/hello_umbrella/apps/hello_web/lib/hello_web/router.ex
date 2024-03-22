defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HelloWeb do
    pipe_through :api
    get "/health-check", HealthCheckController, :index
    get "/calc", CalcController, :index
    post "/calc", CalcController, :index
  end
end
