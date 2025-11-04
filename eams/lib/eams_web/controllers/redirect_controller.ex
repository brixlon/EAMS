defmodule EamsWeb.RedirectController do
  use EamsWeb, :controller

  def dashboard(conn, _params) do
    redirect(conn, to: "/dashboard")
  end
end
