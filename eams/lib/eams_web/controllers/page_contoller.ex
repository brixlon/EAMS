defmodule EamsWeb.PageController do
  use EamsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
