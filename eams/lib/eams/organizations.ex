defmodule Eams.Organizations do
  @moduledoc """
  The Orgs context handles organizations, departments, and teams.
  """

  import Ecto.Query, warn: false
  alias Eams.Repo
  alias Eams.Organizations.{Organization, Department, Team}


  def list_organizations do
    Repo.all(Organization) |> Repo.preload(:created_by)
  end

  def get_organization!(id) do
    Repo.get!(Organization, id) |> Repo.preload(:created_by)
  end

  def create_organization(attrs, created_by) do
    %Organization{}
    |> Organization.changeset(Map.put(attrs, :created_by_id, created_by.id))
    |> Repo.insert()
  end

  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  ## Departments

  def list_departments(organization_id) do
    Department
    |> where([d], d.organization_id == ^organization_id)
    |> preload(:organization)
    |> Repo.all()
  end

  def get_department!(id) do
    Repo.get!(Department, id) |> Repo.preload([:organization, :created_by])
  end

  def create_department(attrs, created_by) do
    %Department{}
    |> Department.changeset(Map.put(attrs, :created_by_id, created_by.id))
    |> Repo.insert()
  end

  ## Teams

  def list_teams(department_id) do
    Team
    |> where([t], t.department_id == ^department_id)
    |> preload([:department, :supervisor])
    |> Repo.all()
  end

  def get_team!(id) do
    Repo.get!(Team, id) |> Repo.preload([:department, :supervisor, :members])
  end

  def create_team(attrs, created_by) do
    %Team{}
    |> Team.changeset(Map.put(attrs, :created_by_id, created_by.id))
    |> Repo.insert()
  end

  def assign_supervisor_to_team(%Team{} = team, supervisor_id) do
    team
    |> Team.changeset(%{supervisor_id: supervisor_id})
    |> Repo.update()
  end
end
