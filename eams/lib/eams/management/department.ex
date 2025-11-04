defmodule Eams.Management.Department do
  use Ecto.Schema
  import Ecto.Changeset

  schema "departments" do
    field :name, :string
    field :description, :string
    field :status, :string
    field :organization_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(department, attrs) do
    department
    |> cast(attrs, [:name, :description, :status])
    |> validate_required([:name, :description, :status])
  end
end
