defmodule DiscussWeb.Router do
  use DiscussWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DiscussWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DiscussWeb do
    pipe_through :browser

    get "/", PageController, :home
    
    # 토픽 관련 경로
    get "/topics", TopicController, :index
    get "/topics/new", TopicController, :new
    post "/topics", TopicController, :create
    get "/topics/:id", TopicController, :show
    get "/topics/:id/edit", TopicController, :edit
    put "/topics/:id", TopicController, :update
    delete "/topics/:id", TopicController, :delete
  end

  scope "/api", DiscussWeb do
    pipe_through :api
  end

  if Application.compile_env(:discuss, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DiscussWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
