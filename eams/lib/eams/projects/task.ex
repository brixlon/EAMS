defmodule Eams.Projects.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :status, :string
    field :priority, :string
    field :due_date, :naive_datetime
    field :estimated_hours, :decimal
    field :actual_hours, :decimal
    field :project_id, :id
    field :assigned_to_id, :id
    field :created_by_id, :id
    field :parent_task_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :status, :priority, :due_date, :estimated_hours, :actual_hours])
    |> validate_required([:title, :description, :status, :priority, :due_date, :estimated_hours, :actual_hours])
  end
end
