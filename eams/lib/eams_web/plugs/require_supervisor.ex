defmodule EamsWeb.Plugs.RequireSupervisor do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user.role == "supervisor" do
      conn
    else
      conn
      |> put_flash(:error, "You don't have permission to access this page.")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
