defmodule Eams.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :hashed_password, :string, null: false
      add :full_name, :string, null: false
      add :phone, :string

      # Role: super_supervisor, supervisor, attachee
      add :role, :string, null: false, default: "attachee"

      # For team assignment (supervisors and attachees)
      # We'll add this constraint later after teams table is created
      add :team_id, :integer

      # Password reset
      add :reset_password_token_hash, :string
      add :reset_password_sent_at, :utc_datetime_usec

      # First login tracking
      add :must_change_password, :boolean, default: true
      add :last_login_at, :utc_datetime_usec

      # Account status
      add :is_active, :boolean, default: true

      # Attachee-specific fields
      add :start_date, :date
      add :end_date, :date
      add :skills, {:array, :string}
      add :bio, :text
      add :profile_picture_url, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create index(:users, [:role])
    create index(:users, [:team_id])
    create index(:users, [:is_active])
  end
end
