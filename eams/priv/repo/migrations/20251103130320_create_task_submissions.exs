defmodule Eams.Repo.Migrations.CreateTaskSubmissions do
  use Ecto.Migration

  def change do
    create table(:task_submissions) do
      add :notes, :text
      add :status, :string, default: "submitted" # "submitted", "approved", "rejected"
      add :feedback, :text
      add :revision_requested, :boolean, default: false
      add :task_id, references(:tasks, on_delete: :delete_all), null: false
      add :submitted_by_id, references(:users, on_delete: :nilify_all), null: false
      add :reviewed_by_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:task_submissions, [:task_id])
    create index(:task_submissions, [:submitted_by_id])
  end
end
