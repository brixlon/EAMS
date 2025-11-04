defmodule EamsWeb.DashboardLive do
  use EamsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:sidebar_open, true)
     |> assign(:current_user, nil)
     |> assign(:page_title, "Dashboard")}
  end

  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, assign(socket, :sidebar_open, !socket.assigns.sidebar_open)}
  end

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div class="bg-white rounded-lg shadow p-6">
        <h2 class="text-lg font-semibold text-gray-900 mb-2">Welcome to EAMS</h2>
        <p class="text-gray-600">Employee Attendance Management System</p>
      </div>

      <div class="bg-white rounded-lg shadow p-6">
        <h2 class="text-lg font-semibold text-gray-900 mb-2">Quick Stats</h2>
        <p class="text-3xl font-bold text-indigo-600">0</p>
        <p class="text-sm text-gray-500">Total Attachees</p>
      </div>

      <div class="bg-white rounded-lg shadow p-6">
        <h2 class="text-lg font-semibold text-gray-900 mb-2">Recent Activity</h2>
        <p class="text-gray-600">No recent activity</p>
      </div>
    </div>
    """
  end
end
