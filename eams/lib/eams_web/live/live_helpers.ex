defmodule EamsWeb.LiveHelpers do
  import Phoenix.Component
  import Phoenix.LiveView

  def on_mount(:assign_defaults, _params, _session, socket) do
    {:cont,
     socket
     |> assign_new(:sidebar_open, fn -> true end)
     |> assign_new(:current_user, fn -> nil end)
     |> assign_new(:page_title, fn -> "Dashboard" end)}
  end
end
