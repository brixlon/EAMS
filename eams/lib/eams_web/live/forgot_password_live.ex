defmodule EamsWeb.ForgotPasswordLive do
  use EamsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{"email" => ""}, as: :user))}
  end
  
  def handle_event("send_reset", %{"user" => %{"email" => email}}, socket) do
    IO.inspect(email, label: "Sending reset email to")

    {:noreply,
     socket
     |> put_flash(:info, "If an account exists with that email, you will receive password reset instructions.")
     |> push_navigate(to: ~p"/login")}
  end
end
