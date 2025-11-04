# lib/eams/accounts.ex
defmodule Eams.Accounts do
  @moduledoc """
  The Accounts context handles user management, authentication, and authorization.
  """

  import Ecto.Query, warn: false
  alias Eams.Repo
  alias Eams.Accounts.User

  ## User Registration & Management

  @doc """
  Creates a user with a generated temporary password.
  Used by super_supervisors to create supervisors, and by supervisors to create attachees.
  Returns {:ok, user, generated_password}
  """
  def create_user_with_temp_password(attrs, created_by_user) do
    # Generate password first
    generated_password = User.generate_secure_password()

    # Add password to attrs
    attrs_with_password =
      attrs
      |> Map.put("password", generated_password)
      |> Map.put("password_confirmation", generated_password)

    result =
      %User{}
      |> User.registration_changeset(attrs_with_password, hash_password: true)
      |> Repo.insert()

    case result do
      {:ok, user} ->
        # TODO: Send welcome email with temporary credentials
        # UserNotifier.deliver_welcome_email(user, generated_password, created_by_user)
        {:ok, user, generated_password}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Creates a user (for manual registration or when password is provided).
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs, hash_password: true)
    |> Repo.insert()
  end

  @doc """
  Gets a single user by ID.
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a user by email.
  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by email and password.
  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Lists all users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Lists users by role.
  """
  def list_users_by_role(role) do
    User
    |> where([u], u.role == ^role)
    |> Repo.all()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.registration_changeset(attrs, hash_password: true)
    |> Repo.update()
  end

  @doc """
  Updates user password.
  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs, hash_password: true)
      |> User.validate_current_password(password)

    Repo.update(changeset)
  end

  @doc """
  Changes user password (without requiring current password).
  Used for first-time password change or password reset.
  """
  def change_user_password(user, attrs \\ %{}) do
    user
    |> User.password_changeset(attrs, hash_password: true)
    |> Repo.update()
  end

  @doc """
  Deactivates a user account.
  """
  def deactivate_user(%User{} = user) do
    user
    |> Ecto.Changeset.change(is_active: false)
    |> Repo.update()
  end

  @doc """
  Reactivates a user account.
  """
  def reactivate_user(%User{} = user) do
    user
    |> Ecto.Changeset.change(is_active: true)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Generates a password changeset for resetting a user's password.
  """
  def change_password(%User{} = user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  ## Authorization Helpers

  @doc """
  Checks if user is a super supervisor.
  """
  def super_supervisor?(%User{role: "super_supervisor"}), do: true
  def super_supervisor?(_), do: false

  @doc """
  Checks if user is a supervisor.
  """
  def supervisor?(%User{role: "supervisor"}), do: true
  def supervisor?(_), do: false

  @doc """
  Checks if user is an attachee.
  """
  def attachee?(%User{role: "attachee"}), do: true
  def attachee?(_), do: false
end
