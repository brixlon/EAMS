defmodule EamsWeb.Layouts do
  @moduledoc """
  Defines the global application layout structure.
  This includes sidebar, navbar, footer, and flash helpers.
  """

  use EamsWeb, :html

  # Embed all HEEx templates under layouts/*
  embed_templates "layouts/*"

  attr :flash, :map, required: true
  attr :id, :string, default: "flash-group"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} class="fixed top-4 right-4 z-50 space-y-2" aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={JS.show(to: ".phx-client-error #client-error")}
        phx-connected={JS.hide(to: "#client-error")}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={JS.show(to: ".phx-server-error #server-error")}
        phx-connected={JS.hide(to: "#server-error")}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  # Theme toggle stays unchanged
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-white/20 bg-white/10 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full bg-white/30 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3 relative z-10"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
        title="System theme"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3 relative z-10"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
        title="Light theme"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3 relative z-10"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
        title="Dark theme"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end

  # This is your universal layout wrapper
  attr :current_user, :map, default: nil
  attr :flash, :map, default: %{}
  attr :page_title, :string, default: "Dashboard"
  slot :inner_content, required: true

  def app_layout(assigns) do
    ~H"""
    <div class="flex w-full min-h-screen">
      <.live_component module={EamsWeb.SidebarComponent} id="sidebar" current_user={@current_user} />

      <div class="flex-1 flex flex-col">
        <header class="bg-white border-b border-gray-200 px-8 py-4">
          <div class="flex items-center justify-between">
            <h1 class="text-2xl font-semibold text-gray-800">
              <%= @page_title %>
            </h1>
            <button class="md:hidden btn btn-ghost">
              <.icon name="hero-bars-3" class="size-6" />
            </button>
          </div>
        </header>

        <main class="flex-1 p-8 overflow-y-auto bg-gray-50">
          <.flash_group flash={@flash} />
          <%= render_slot(@inner_content) %>
        </main>

        <footer class="bg-white border-t border-gray-200 px-8 py-4">
          <p class="text-sm text-gray-600 text-center">
            © <%= DateTime.utc_now().year %> EAMS - Enterprise Attachment Management System
          </p>
        </footer>
      </div>
    </div>
    """
  end

  # Flash component
  attr :kind, :atom, values: [:info, :error], default: :info
  attr :flash, :map, default: %{}
  attr :title, :string, default: nil
  attr :id, :string, default: nil
  attr :rest, :global, default: %{}
  slot :inner_block, required: false

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> JS.hide(to: "##{@id}")}
      role="alert"
      class={[
        "flex items-center gap-3 rounded-lg p-4 shadow-md cursor-pointer",
        @kind == :info && "bg-blue-50 text-blue-900 border border-blue-200",
        @kind == :error && "bg-red-50 text-red-900 border border-red-200"
      ]}
      {@rest}
    >
      <.icon :if={@kind == :info} name="hero-information-circle-mini" class="size-5" />
      <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="size-5" />
      <div class="flex-1">
        <p :if={@title} class="font-semibold"><%= @title %></p>
        <p class="text-sm"><%= msg %></p>
      </div>
    </div>
    """
  end

  # Icon component
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end
end
