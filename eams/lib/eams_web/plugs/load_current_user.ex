defmodule EamsWeb.Plugs.LoadCurrentUser do
  import Plug.Conn
  alias Eams.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :user_id) do
      nil ->
        assign(conn, :current_user, nil)

      user_id ->
        user = Accounts.get_user!(user_id)
        conn
        |> assign(:current_user, user)
        |> assign(:active_tab, nil)
    end
  end
end
