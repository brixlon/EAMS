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

  # New pipeline that adds app layout
  pipeline :app_layout do
    plug :put_layout, html: {EamsWeb.Layouts, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EamsWeb do
    pipe_through [:browser, :app_layout]  # Add app_layout pipeline

    get "/", PageController, :home
  end

  # Development routes without app layout
  if Application.compile_env(:eams, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser  # Only browser pipeline, no app layout

      live_dashboard "/dashboard", metrics: EamsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
