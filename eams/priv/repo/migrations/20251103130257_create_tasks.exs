defmodule Eams.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text
      add :status, :string, default: "pending"
      add :priority, :string, default: "medium"
      add :due_date, :naive_datetime
      add :estimated_hours, :decimal
      add :actual_hours, :decimal
      add :project_id, references(:projects, on_delete: :delete_all), null: false
      add :assigned_to_id, references(:users, on_delete: :nilify_all)
      add :created_by_id, references(:users, on_delete: :nilify_all)
      add :parent_task_id, references(:tasks, on_delete: :nilify_all)

      timestamps()
    end

    create index(:tasks, [:project_id])
    create index(:tasks, [:assigned_to_id])
    create index(:tasks, [:created_by_id])
    create index(:tasks, [:parent_task_id])
  end
end
