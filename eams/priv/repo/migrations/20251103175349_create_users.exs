defmodule EamsWeb.Router do
  use EamsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EamsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :app_layout do
    plug :put_layout, html: {EamsWeb.Layouts, :app}
  end

  # Public routes (no authentication required)
  scope "/", EamsWeb do
    pipe_through :browser

    live "/login", LoginLive, :index
    live "/forgot-password", ForgotPasswordLive, :index
  end

  # Protected routes (authentication required)
  live_session :default,
    on_mount: [{EamsWeb.LiveHelpers, :assign_defaults}],
    layout: {EamsWeb.Layouts, :app} do

    scope "/", EamsWeb do
      pipe_through [:browser, :app_layout]
      live "/", DashboardLive, :index
    end
  end
end
