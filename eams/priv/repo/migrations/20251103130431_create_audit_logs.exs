defmodule Eams.Repo.Migrations.CreateAuditLogs do
  use Ecto.Migration

  def change do
    create table(:audit_logs) do
      add :action, :string, null: false
      add :resource_type, :string, null: false
      add :resource_id, :integer
      add :changes, :map, default: %{}
      add :ip_address, :string
      add :user_agent, :string
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps(updated_at: false)
    end

    create index(:audit_logs, [:user_id])
    create index(:audit_logs, [:resource_type, :resource_id])
    create index(:audit_logs, [:inserted_at])
  end
end
