# lib/eams/orgs/organization.ex
defmodule Eams.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :address, :string
    field :phone, :string
    field :email, :string
    field :website, :string
    field :is_active, :boolean, default: true
    field :logo_url, :string
    field :primary_color, :string
    field :secondary_color, :string

    belongs_to :created_by, Eams.Accounts.User
    has_many :departments, Eams.Orgs.Department

    timestamps()
  end

  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [
      :name,
      :code,
      :description,
      :address,
      :phone,
      :email,
      :website,
      :is_active,
      :logo_url,
      :primary_color,
      :secondary_color,
      :created_by_id
    ])
    |> validate_required([:name, :code])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> unique_constraint(:code)
  end
end
