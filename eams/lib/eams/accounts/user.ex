# lib/eams/accounts/user.ex
defmodule Eams.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @roles ~w(super_supervisor supervisor attachee)

  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :full_name, :string
    field :phone, :string
    field :role, :string, default: "attachee"

    # Password fields (virtual)
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    # Password reset
    field :reset_password_token_hash, :string
    field :reset_password_sent_at, :utc_datetime_usec

    # First login tracking
    field :must_change_password, :boolean, default: true
    field :last_login_at, :utc_datetime_usec

    # Account status
    field :is_active, :boolean, default: true

    # Attachee-specific fields
    field :start_date, :date
    field :end_date, :date
    field :skills, {:array, :string}
    field :bio, :string
    field :profile_picture_url, :string

    # Relationships (will be added after creating other schemas)
    # belongs_to :team, Eams.Orgs.Team

    timestamps()
  end

  @doc """
  Changeset for user creation with generated temporary password.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [
      :email,
      :full_name,
      :phone,
      :role,
      :team_id,
      :start_date,
      :end_date,
      :skills,
      :password,
      :password_confirmation
    ])
    |> validate_required([:email, :full_name, :role])
    |> validate_email()
    |> validate_inclusion(:role, @roles)
    |> maybe_generate_password(opts)
    |> validate_password(opts)
    |> unique_constraint(:email)
  end

  @doc """
  Changeset for password changes.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password])
    |> validate_password(opts)
    |> put_change(:must_change_password, false)
  end

  @doc """
  Validates the email.
  """
  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/, message: "must be a valid email")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Eams.Repo)
    |> unique_constraint(:email)
  end

  @doc """
  Validates the password.
  """
  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72)
    |> validate_format(:password, ~r/[A-Z]/, message: "must include at least one uppercase letter")
    |> validate_format(:password, ~r/[a-z]/, message: "must include at least one lowercase letter")
    |> validate_format(:password, ~r/[0-9]/, message: "must include at least one number")
    |> validate_format(:password, ~r/[!@#$%^&*(),.?":{}|<>]/, message: "must include at least one special character")
    |> validate_confirmation(:password, message: "does not match password")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
      |> delete_change(:password_confirmation)
    else
      changeset
    end
  end

  @doc """
  Generates a secure temporary password if not provided.
  """
  defp maybe_generate_password(changeset, opts) do
    if Keyword.get(opts, :auto_generate_password, false) do
      password = get_field(changeset, :password)

      if is_nil(password) || password == "" do
        generated_password = generate_secure_password()

        changeset
        |> put_change(:password, generated_password)
        |> put_change(:password_confirmation, generated_password)
        |> put_change(:must_change_password, true)
      else
        changeset
      end
    else
      changeset
    end
  end

  @doc """
  Generates a secure temporary password.
  Format: Uppercase + Lowercase + Numbers + Special + Random mix
  Example: TempPass@2024XyZ1
  """
  def generate_secure_password do
    uppercase = Enum.random(?A..?Z)
    lowercase = Enum.random(?a..?z)
    number = Enum.random(?0..?9)
    special = Enum.random(~c"!@#$%^&*")

    # Generate 8 more random characters
    random_chars =
      for _ <- 1..8 do
        Enum.random([
          Enum.random(?A..?Z),
          Enum.random(?a..?z),
          Enum.random(?0..?9),
          Enum.random(~c"!@#$%^&*")
        ])
      end

    # Shuffle all characters
    [uppercase, lowercase, number, special | random_chars]
    |> Enum.shuffle()
    |> List.to_string()
  end

  @doc """
  Verifies the password against stored hash.
  """
  def valid_password?(%__MODULE__{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
