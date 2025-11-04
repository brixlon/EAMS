defmodule Eams.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false
      add :description, :text
      add :status, :string, default: "active"
      add :settings, :map, default: %{}

      timestamps()
    end

    create unique_index(:organizations, [:name])
  end
end
