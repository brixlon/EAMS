defmodule Eams.Management.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :description, :string
    field :specialization, :string
    field :max_attachees, :integer
    field :status, :string
    field :department_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :description, :specialization, :max_attachees, :status])
    |> validate_required([:name, :description, :specialization, :max_attachees, :status])
  end
end
