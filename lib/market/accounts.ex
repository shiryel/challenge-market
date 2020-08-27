defmodule Market.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Market.Repo

  ########
  # USER #
  ########

  alias Market.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user with email info
  ## Examples
      iex> get_user_by_email("dio@hotmail.com")
      %User{}
      iex> get_user_by_email("haha")
      nil
  """
  @spec get_user_by_email(:string) :: %User{} | nil
  def get_user_by_email(email) do
    Repo.one(
      from u in User,
        where: u.email == ^email
    )
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.registration_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end

  @doc """
  Verify the password using the Argon2
      iex> authenticate("jotaro@hotmail.com", "secret")
      {:ok, %User{}}
      iex> authenticate("dio@com", "no no no no")
      {:error, "not found"}
      iex> authenticate("dio@hotmail.com", "no no no no")
      {:error, "invalid password"}
  """
  @spec authenticate(:string, :string) :: {:ok, %User{}} | {:error, bitstring()}
  def authenticate(email, password) do
    case get_user_by_email(email) do
      nil ->
        # Run a dummy check, which always returns false, to make user enumeration more difficult
        Argon2.no_user_verify()
        {:error, "not found"}

      user ->
        Argon2.check_pass(user, password)
    end
  end
end
