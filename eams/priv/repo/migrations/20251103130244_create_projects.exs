defmodule Eams.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :description, :text
      add :start_date, :date
      add :end_date, :date
      add :status, :string, default: "active"
      add :priority, :string, default: "medium"
      add :team_id, references(:teams, on_delete: :delete_all), null: false
      add :created_by_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:projects, [:team_id])
    create index(:projects, [:created_by_id])
  end
end
