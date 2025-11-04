# lib/eams/orgs/team.ex
defmodule Eams.Organizations.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :specialization, :string
    field :max_attachees, :integer, default: 10
    field :is_active, :boolean, default: true

    belongs_to :department, Eams.Orgs.Department
    belongs_to :supervisor, Eams.Accounts.User
    belongs_to :created_by, Eams.Accounts.User

    has_many :members, Eams.Accounts.User, foreign_key: :team_id
    has_many :projects, Eams.Projects.Project

    timestamps()
  end

  def changeset(team, attrs) do
    team
    |> cast(attrs, [
      :name,
      :code,
      :description,
      :specialization,
      :max_attachees,
      :is_active,
      :department_id,
      :supervisor_id,
      :created_by_id
    ])
    |> validate_required([:name, :code, :department_id])
    |> validate_number(:max_attachees, greater_than: 0)
    |> unique_constraint([:department_id, :code])
  end
end
