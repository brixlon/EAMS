defmodule Eams.Organizations.Department do
  use Ecto.Schema
  import Ecto.Changeset

  schema "departments" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :is_active, :boolean, default: true

    belongs_to :organization, Eams.Organizations.Organization
    belongs_to :created_by, Eams.Accounts.User
    has_many :teams, Eams.Organizations.Team

    timestamps()
  end

  def changeset(department, attrs) do
    department
    |> cast(attrs, [:name, :code, :description, :is_active, :organization_id, :created_by_id])
    |> validate_required([:name, :code, :organization_id])
    |> unique_constraint([:organization_id, :code])
  end
end
