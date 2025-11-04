defmodule Eams.Performance.Evaluation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "evaluations" do
    field :evaluation_type, :string
    field :period_start, :date
    field :period_end, :date
    field :rating, :decimal
    field :comments, :string
    field :strengths, :string
    field :areas_for_improvement, :string
    field :competency_ratings, :map
    field :attachee_id, :id
    field :supervisor_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(evaluation, attrs) do
    evaluation
    |> cast(attrs, [:evaluation_type, :period_start, :period_end, :rating, :comments, :strengths, :areas_for_improvement, :competency_ratings])
    |> validate_required([:evaluation_type, :period_start, :period_end, :rating, :comments, :strengths, :areas_for_improvement])
  end
end
