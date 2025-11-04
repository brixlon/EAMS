defmodule EamsWeb.SessionController do
  use EamsWeb, :controller

  # Minimal redirect to root path
  def create(conn, _params) do
    conn
    |> put_flash(:info, "Login placeholder")
    |> redirect(to: Routes.dashboard_path(conn, :index))
  end
end
