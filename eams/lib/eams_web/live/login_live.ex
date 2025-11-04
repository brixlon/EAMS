defmodule EamsWeb.LoginLive do
  use EamsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{"email" => "", "password" => ""}, as: :user))}
  end

  def handle_event("login", %{"user" => %{"email" => email, "password" => password}}, socket) do
    IO.inspect(email, label: "Email")
    IO.inspect(password, label: "Password")

    {:noreply, push_navigate(socket, to: ~p"/")}
  end
end
