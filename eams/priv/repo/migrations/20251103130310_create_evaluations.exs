defmodule Eams.Repo.Migrations.CreateEvaluations do
  use Ecto.Migration

  def change do
    create table(:evaluations) do
      add :evaluation_type, :string, null: false # "weekly", "monthly", "final"
      add :period_start, :date, null: false
      add :period_end, :date, null: false
      add :rating, :decimal
      add :comments, :text
      add :strengths, :text
      add :areas_for_improvement, :text
      add :competency_ratings, :map, default: %{}
      add :attachee_id, references(:users, on_delete: :delete_all), null: false
      add :supervisor_id, references(:users, on_delete: :nilify_all), null: false

      timestamps()
    end

    create index(:evaluations, [:attachee_id])
    create index(:evaluations, [:supervisor_id])
  end
end
