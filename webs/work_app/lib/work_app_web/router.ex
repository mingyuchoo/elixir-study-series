defmodule WorkAppWeb.Router do
  use WorkAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WorkAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WorkAppWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/lists", ListLive.Index, :index
    live "/lists/new", ListLive.Index, :new
    live "/lists/:id/edit", ListLive.Index, :edit

    live "/lists/:id", ListLive.Show, :show
    live "/lists/:id/show/edit", ListLive.Show, :edit

    live "/items", ItemLive.Index, :index
    live "/items/new", ItemLive.Index, :new
    live "/items/:id/edit", ItemLive.Index, :edit

    live "/items/:id", ItemLive.Show, :show
    live "/items/:id/show/edit", ItemLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", WorkAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:work_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WorkAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
