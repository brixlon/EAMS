defmodule Eams.Storage.Attachment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "attachments" do
    field :filename, :string
    field :file_path, :string
    field :file_type, :string
    field :file_size, :integer
    field :attachable_type, :string
    field :attachable_id, :integer
    field :uploaded_by_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(attachment, attrs) do
    attachment
    |> cast(attrs, [:filename, :file_path, :file_type, :file_size, :attachable_type, :attachable_id])
    |> validate_required([:filename, :file_path, :file_type, :file_size, :attachable_type, :attachable_id])
  end
end
