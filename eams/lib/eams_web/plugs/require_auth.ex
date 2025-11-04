defmodule EamsWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      # Check if password must be changed
      if conn.assigns.current_user.must_change_password &&
         !String.contains?(conn.request_path, "change-password") do
        conn
        |> put_flash(:error, "You must change your password before continuing.")
        |> redirect(to: "/change-password")
        |> halt()
      else
        conn
      end
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page.")
      |> redirect(to: "/login")
      |> halt()
    end
  end
end
