defmodule EamsWeb.DashboardLive do
  use EamsWeb, :live_view
  alias Eams.Attendance
  alias Eams.Employees

  def mount(_params, _session, socket) do
    if connected?(socket) do
      # Subscribe to real-time updates
      Phoenix.PubSub.subscribe(Eams.PubSub, "attendance_updates")
      Phoenix.PubSub.subscribe(Eams.PubSub, "employee_updates")
    end

    {:ok,
     socket
     |> assign(:sidebar_open, true)
     |> assign(:current_user, nil)
     |> assign(:page_title, "Dashboard")
     |> assign(:loading, true)
     |> load_dashboard_data()}
  end

  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, assign(socket, :sidebar_open, !socket.assigns.sidebar_open)}
  end

  def handle_event("refresh_stats", _params, socket) do
    # Set loading state first
    socket = assign(socket, :loading, true)

    # Send a message to self to reload data after a brief moment
    # This ensures the loading state is rendered before data reload
    send(self(), :reload_data)

    {:noreply, socket}
  end

  def handle_info(:reload_data, socket) do
    {:noreply, load_dashboard_data(socket)}
  end

  def handle_info({:attendance_updated, _data}, socket) do
    {:noreply, load_dashboard_data(socket)}
  end

  def handle_info({:employee_updated, _data}, socket) do
    {:noreply, load_dashboard_data(socket)}
  end

  defp load_dashboard_data(socket) do
    # Simulate loading data - replace with actual queries
    today = Date.utc_today()

    stats = %{
      total_attachees: get_total_attachees(),
      on_leave: get_on_leave(today),
      attendance_rate: calculate_attendance_rate(today)
    }

    recent_activity = get_recent_activity(10)
    upcoming_leaves = get_upcoming_leaves(7)
    socket
    |> assign(:stats, stats)
    |> assign(:recent_activity, recent_activity)
    |> assign(:upcoming_leaves, upcoming_leaves)
    |> assign(:current_date, today)
    |> assign(:loading, false)
  end

  # Placeholder functions - implement with actual database queries
  defp get_total_attachees, do: 0
  defp get_on_leave(_date), do: 0
  defp calculate_attendance_rate(_date), do: 0.0
  defp get_recent_activity(_limit), do: []
  defp get_upcoming_leaves(_days), do: []

end
