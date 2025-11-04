defmodule Eams.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Eams.Repo
  alias Eams.Accounts.User

  ## User functions

  @doc """
  Returns all users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user by ID.

  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user!(id) do
    Repo.get!(User, id)
  end

  @doc """
  Gets a user by email, returns nil if not found.
  """
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Creates a user (registration by admin).
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.registration_changeset(attrs)
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
    User.registration_changeset(user, attrs)
  end

  ## Password reset functions

  @doc """
  Generates a password changeset for resetting a user's password.
  """
  def change_password(%User{} = user, attrs \\ %{}) do
    User.password_changeset(user, attrs)
  end

  @doc """
  Updates a user's password (after reset).
  """
  def update_password(%User{} = user, attrs) do
    user
    |> User.password_changeset(attrs)
    |> Repo.update()
  end
end
