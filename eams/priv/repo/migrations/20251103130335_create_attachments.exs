defmodule Eams.Repo.Migrations.CreateAttachments do
  use Ecto.Migration

  def change do
    create table(:attachments) do
      add :filename, :string, null: false
      add :file_path, :string, null: false
      add :file_type, :string
      add :file_size, :integer
      add :attachable_type, :string, null: false # "Task", "TaskSubmission", "Project"
      add :attachable_id, :integer, null: false
      add :uploaded_by_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:attachments, [:attachable_type, :attachable_id])
    create index(:attachments, [:uploaded_by_id])
  end
end
