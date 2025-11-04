defmodule Eams.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :description, :text
      add :specialization, :string
      add :max_attachees, :integer, default: 10
      add :status, :string, default: "active"
      add :department_id, references(:departments, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:teams, [:department_id])
    create unique_index(:teams, [:department_id, :name])
  end
end
