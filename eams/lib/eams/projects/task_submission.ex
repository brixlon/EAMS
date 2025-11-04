defmodule Eams.Projects.TaskSubmission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_submissions" do
    field :notes, :string
    field :status, :string
    field :feedback, :string
    field :revision_requested, :boolean, default: false
    field :task_id, :id
    field :submitted_by_id, :id
    field :reviewed_by_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task_submission, attrs) do
    task_submission
    |> cast(attrs, [:notes, :status, :feedback, :revision_requested])
    |> validate_required([:notes, :status, :feedback, :revision_requested])
  end
end
