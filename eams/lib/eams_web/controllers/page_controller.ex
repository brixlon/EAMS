defmodule EamsWeb.PageController do
  use EamsWeb, :controller

  def home(conn, _params) do
    conn
    |> put_layout(html: :app)  # Use app layout
    |> assign(:page_title, "Dashboard")
    |> render(:home)
  end
end
