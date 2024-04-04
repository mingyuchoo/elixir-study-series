defmodule DemoWeb.Router do
  use DemoWeb, :router

  import DemoWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {DemoWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", DemoWeb do
    pipe_through(:browser)

    get("/", HomeController, :index)
  end

  scope "/api", DemoWeb do
    pipe_through(:api)

    get("/health-check", HealthCheckController, :index)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:demo_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: DemoWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", DemoWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{DemoWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserLive.Registration, :new)
      live("/users/log_in", UserLive.Login, :new)
      live("/users/reset_password", UserLive.ForgotPassword, :new)
      live("/users/reset_password/:token", UserLive.ResetPassword, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", DemoWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{DemoWeb.UserAuth, :ensure_authenticated}] do
      live("/users/settings", UserLive.Settings, :edit)
      live("/users/settings/confirm_email/:token", UserLive.Settings, :confirm_email)

      live("/todos/lists", ListLive.Index, :index)
      live("/todos/lists/new", ListLive.Index, :new)
      live("/todos/lists/:id/edit", ListLive.Index, :edit)
      live("/todos/lists/:id", ListLive.Show, :show)
      live("/todos/lists/:id/show/edit", ListLive.Show, :edit)

      live("/todos/items", ItemLive.Index, :index)
      live("/todos/items/new", ItemLive.Index, :new)
      live("/todos/items/:id/edit", ItemLive.Index, :edit)
      live("/todos/items/:id", ItemLive.Show, :show)
      live("/todos/items/:id/show/edit", ItemLive.Show, :edit)

      live("/accounts/roles", RoleLive.Index, :index)
      live("/accounts/roles/new", RoleLive.Index, :new)
      live("/accounts/roles/:id/edit", RoleLive.Index, :edit)
      live("/accounts/roles/:id", RoleLive.Show, :show)
      live("/accounts/roles/:id/show/edit", RoleLive.Show, :edit)

      live("/accounts/users", UserLive.Index, :index)
      live("/accounts/users/new", UserLive.Index, :new)
      live("/accounts/users/:id/edit", UserLive.Index, :edit)
      live("/accounts/users/:id", UserLive.Show, :show)
      live("/accounts/users/:id/show/edit", UserLive.Show, :edit)
    end
  end

  scope "/", DemoWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{DemoWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserLive.Confirmation, :edit)
      live("/users/confirm", UserLive.ConfirmationInstructions, :new)
    end
  end
end
