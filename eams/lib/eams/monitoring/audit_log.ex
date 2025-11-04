defmodule Eams.Monitoring.AuditLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "audit_logs" do
    field :action, :string
    field :resource_type, :string
    field :resource_id, :integer
    field :changes, :map
    field :ip_address, :string
    field :user_agent, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(audit_log, attrs) do
    audit_log
    |> cast(attrs, [:action, :resource_type, :resource_id, :changes, :ip_address, :user_agent])
    |> validate_required([:action, :resource_type, :resource_id, :ip_address, :user_agent])
  end
end
