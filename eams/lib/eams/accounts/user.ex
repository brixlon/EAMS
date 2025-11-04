defmodule Eams.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @roles ~w(super_supervisor supervisor attachee admin)

  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :role, :string, default: "attachee"

    # virtual fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    # password reset
    field :reset_password_token_hash, :string
    field :reset_password_sent_at, :utc_datetime_usec

    timestamps()
  end

  @doc """
  Changeset used when creating a user (by admin/provisioning).
  Expects a plain `:password` and sets `hashed_password`.
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation, :role])
    |> validate_required([:email, :password, :role])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_inclusion(:role, @roles)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, message: "does not match confirmation")
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  @doc """
  Changeset for updating password (used by reset flow).
  """
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, message: "does not match confirmation")
    |> put_password_hash()
    |> remove_reset_token()
  end

  defp put_password_hash(changeset) do
    if pass = get_change(changeset, :password) do
      put_change(changeset, :hashed_password, Bcrypt.hash_pwd_salt(pass))
    else
      changeset
    end
  end

  defp remove_reset_token(changeset) do
    changeset
    |> put_change(:reset_password_token_hash, nil)
    |> put_change(:reset_password_sent_at, nil)
  end
end
