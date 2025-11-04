defmodule Eams.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :description, :string
    field :start_date, :date
    field :end_date, :date
    field :status, :string
    field :priority, :string
    field :team_id, :id
    field :created_by_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :start_date, :end_date, :status, :priority])
    |> validate_required([:name, :description, :start_date, :end_date, :status, :priority])
  end
end
