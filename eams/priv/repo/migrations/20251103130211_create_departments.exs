defmodule Eams.Repo.Migrations.CreateDepartments do
  use Ecto.Migration

  def change do
    create table(:departments) do
      add :name, :string, null: false
      add :description, :text
      add :status, :string, default: "active"
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:departments, [:organization_id])
    create unique_index(:departments, [:organization_id, :name])
  end
end
