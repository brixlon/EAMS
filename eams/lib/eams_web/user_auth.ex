defmodule EamsWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias EamsWeb.Endpoint

  # Redirect if already logged in
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: path(conn, "/dashboard"))
      |> halt()
    else
      conn
    end
  end

  # Require login
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to continue.")
      |> redirect(to: path(conn, "/login"))
      |> halt()
    end
  end

  # Role-based access
  def require_supervisor(conn, _opts), do: require_role(conn, "supervisor")
  def require_super_supervisor(conn, _opts), do: require_role(conn, "super_supervisor")
  def require_attachee(conn, _opts), do: require_role(conn, "attachee")

  # Fetch the logged-in user from the session
  def fetch_current_user(conn, _opts) do
    user_id = get_session(conn, :user_id)

    user =
      if user_id do
        Eams.Accounts.get_user!(user_id)
      else
        nil
      end

    assign(conn, :current_user, user)
  end

  # Private helper to check roles
  defp require_role(conn, role) do
    case conn.assigns[:current_user] do
      %{role: ^role} ->
        conn

      _ ->
        conn
        |> put_flash(:error, "Unauthorized access")
        |> redirect(to: path(conn, "/dashboard"))
        |> halt()
    end
  end

  # ✅ Safe, future-proof helper for Phoenix 1.8+
  # Builds a path without relying on deprecated helpers or verified routes macros
  defp path(conn, route) do
    Phoenix.Controller.current_path(conn) |> Kernel.<>(route) |> normalize_path()
  end

  defp normalize_path("/" <> rest), do: "/" <> rest
  defp normalize_path(path), do: path
end
