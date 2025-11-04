defmodule Eams.Management.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :description, :string
    field :status, :string
    field :settings, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :description, :status, :settings])
    |> validate_required([:name, :description, :status])
    |> unique_constraint(:name)
  end
end
