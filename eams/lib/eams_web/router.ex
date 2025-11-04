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

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes (no authentication required)
  live_session :public,
    layout: {EamsWeb.Layouts, :root} do

    scope "/", EamsWeb do
      pipe_through :browser

      live "/login", LoginLive, :index
      live "/forgot-password", ForgotPasswordLive, :index
    end
  end

  # Main app routes (Dashboard + user pages)
  live_session :default,
    layout: {EamsWeb.Layouts, :app} do

    scope "/", EamsWeb do
      pipe_through [:browser, :app_layout]

      live "/", DashboardLive, :index
      live "/dashboard", DashboardLive, :index
      live "/profile", ProfileLive, :index
      live "/change-password", ChangePasswordLive, :index
    end
  end

  # Admin routes
  live_session :admin,
    layout: {EamsWeb.Layouts, :app} do

    scope "/admin", EamsWeb.Admin do
      pipe_through [:browser, :app_layout]

      live "/organizations", OrganizationLive.Index, :index
      live "/organizations/new", OrganizationLive.New, :new
      live "/organizations/:id", OrganizationLive.Show, :show

      live "/departments", DepartmentLive.Index, :index
      live "/teams", TeamLive.Index, :index
      live "/supervisors", SupervisorLive.Index, :index
    end
  end

  # Supervisor routes
  live_session :supervisor,
    layout: {EamsWeb.Layouts, :app} do

    scope "/supervisor", EamsWeb.Supervisor do
      pipe_through [:browser, :app_layout]

      live "/team", TeamDashboardLive, :index
      live "/attachees", AttacheeLive.Index, :index
      live "/attachees/new", AttacheeLive.New, :new
      live "/projects", ProjectLive.Index, :index
      live "/tasks", TaskLive.Index, :index
      live "/evaluations", EvaluationLive.Index, :index
    end
  end

  # Attachee routes
  live_session :attachee,
    layout: {EamsWeb.Layouts, :app} do

    scope "/attachee", EamsWeb.Attachee do
      pipe_through [:browser, :app_layout]

      live "/my-tasks", MyTasksLive, :index
      live "/my-projects", MyProjectsLive, :index
      live "/my-evaluations", MyEvaluationsLive, :index
    end
  end
end
