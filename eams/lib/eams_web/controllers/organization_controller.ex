defmodule EamsWeb.OrganizationController do
  use EamsWeb, :controller

  alias EamsWeb.Organizations
  alias Eams.Organizations.Organization

  plug :put_layout, html: {EamsWeb.Layouts, :app}

  def index(conn, _params) do
    organizations = Organizations.list_organizations()

    conn
    |> assign(:page_title, "Organizations")
    |> assign(:active_tab, "organizations")
    |> render(:index, organizations: organizations)
  end

  def new(conn, _params) do
    changeset = Organization.changeset(%Organization{}, %{})

    conn
    |> assign(:page_title, "New Organization")
    |> assign(:active_tab, "organizations")
    |> render(:new, changeset: changeset)
  end

  def create(conn, %{"organization" => organization_params}) do
    case Organizations.create_organization(organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization created successfully.")
        |> redirect(to: ~p"/organizations/#{organization}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:page_title, "New Organization")
        |> assign(:active_tab, "organizations")
        |> render(:new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)

    conn
    |> assign(:page_title, organization.name)
    |> assign(:active_tab, "organizations")
    |> render(:show, organization: organization)
  end

  def edit(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)
    changeset = Organization.changeset(organization, %{})

    conn
    |> assign(:page_title, "Edit #{organization.name}")
    |> assign(:active_tab, "organizations")
    |> render(:edit, organization: organization, changeset: changeset)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Organizations.get_organization!(id)

    case Organizations.update_organization(organization, organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization updated successfully.")
        |> redirect(to: ~p"/organizations/#{organization}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:page_title, "Edit #{organization.name}")
        |> assign(:active_tab, "organizations")
        |> render(:edit, organization: organization, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)
    {:ok, _organization} = Organizations.delete_organization(organization)

    conn
    |> put_flash(:info, "Organization deleted successfully.")
    |> redirect(to: ~p"/organizations")
  end
end
