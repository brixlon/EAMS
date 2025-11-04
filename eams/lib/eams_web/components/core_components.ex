defmodule EamsWeb.CoreComponents do
  use Phoenix.Component

  # Error tag component using modern Phoenix
  attr :form, :map, required: true
  attr :field, :atom, required: true

  def error_tag(assigns) do
    ~H"""
    <%= for msg <- Keyword.get_values(@form.errors, @field) do %>
      <span class="error text-red-600 text-sm"><%= msg %></span>
    <% end %>
    """
  end
end
