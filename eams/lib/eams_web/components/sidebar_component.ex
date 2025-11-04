defmodule EamsWeb.SidebarComponent do
  use EamsWeb, :live_component
  import Phoenix.LiveView.JS

  @moduledoc """
  Responsive, collapsible sidebar component fixed on the left.
  Collapses into icon-only mode and expands when toggled.
  """

  def render(assigns) do
    ~H"""
    <aside
      id="sidebar"
      class="flex flex-col bg-indigo-600 text-white h-screen transition-all duration-300 overflow-hidden"
      style="width: 16rem"
      phx-hook="SidebarToggle"
    >
      <!-- Toggle Button -->
      <button
        phx-click={toggle_sidebar()}
        class="absolute -right-3 top-6 bg-indigo-500 hover:bg-indigo-400 text-white w-6 h-6 flex items-center justify-center rounded-full shadow"
        title="Toggle sidebar"
      >
        ⇔
      </button>

      <!-- Logo -->
      <div class="p-6 flex items-center gap-2 border-b border-indigo-500">
        <img src={~p"/images/logo.svg"} width="36" alt="EAMS Logo" class="brightness-0 invert" />
        <span class="font-bold text-xl tracking-wide sidebar-text">EAMS</span>
      </div>

      <!-- Navigation -->
      <nav class="flex-1 px-3 py-6 space-y-1 overflow-y-auto">
        <%= for item <- nav_links(@current_user) do %>
          <a
            href={item.path}
            class="flex items-center gap-3 py-2 px-3 rounded-md hover:bg-indigo-500 transition-colors group"
          >
            <span><%= item.icon %></span>
            <span class="sidebar-text"><%= item.label %></span>
          </a>
        <% end %>
      </nav>

      <!-- User Info & Logout -->
      <div class="p-4 border-t border-indigo-500 sidebar-text">
        <%= if @current_user do %>
          <div class="flex items-center gap-3 mb-3">
            <div class="w-10 h-10 rounded-full bg-indigo-800 flex items-center justify-center text-white font-semibold">
              <%= String.first(@current_user.email) |> String.upcase() %>
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium truncate"><%= @current_user.email %></p>
              <p class="text-xs text-indigo-200 capitalize"><%= @current_user.role %></p>
            </div>
          </div>
          <a
            href={~p"/users/settings"}
            class="block w-full py-2 px-3 text-sm rounded hover:bg-indigo-500 text-center mb-2 transition"
          >
            ⚙️ Settings
          </a>
          <a
            href={~p"/users/log_out"}
            data-method="delete"
            class="block w-full py-2 px-3 text-sm rounded hover:bg-indigo-500 text-center transition"
          >
            🚪 Log out
          </a>
        <% else %>
          <a
            href={~p"/users/log_in"}
            class="block w-full py-2 px-3 text-sm rounded hover:bg-indigo-500 text-center transition"
          >
            🔐 Log in
          </a>
        <% end %>
      </div>
    </aside>
    """
  end

  # JS command: toggles sidebar width and text visibility
  defp toggle_sidebar do
    JS.toggle_class("w-16", to: "#sidebar")
    |> JS.toggle_class("hidden", to: "#sidebar .sidebar-text")
  end

  # Menu items per role
  defp nav_links(current_user) do
    base_links = [
      %{label: "Dashboard", path: ~p"/", icon: "🏠"},
      %{label: "Organizations", path: ~p"/organizations", icon: "🏢"},
      %{label: "Departments", path: ~p"/departments", icon: "🏛"},
      %{label: "Teams", path: ~p"/teams", icon: "👥"},
      %{label: "Supervisors", path: ~p"/supervisors", icon: "👔"},
      %{label: "Attachees", path: ~p"/attachees", icon: "🎓"},
      %{label: "Projects", path: ~p"/projects", icon: "📁"},
      %{label: "Reports", path: ~p"/reports", icon: "📊"}
    ]

    cond do
      is_nil(current_user) ->
        base_links

      current_user.role in ["admin", :admin] ->
        base_links ++ [%{label: "System Settings", path: ~p"/admin/settings", icon: "⚙️"}]

      current_user.role in ["supervisor", :supervisor] ->
        Enum.filter(base_links, fn link ->
          link.label in ["Dashboard", "Teams", "Attachees", "Projects", "Reports"]
        end)

      current_user.role in ["attachee", :attachee] ->
        Enum.filter(base_links, fn link ->
          link.label in ["Dashboard", "Projects", "Reports"]
        end)

      true ->
        base_links
    end
  end
end
