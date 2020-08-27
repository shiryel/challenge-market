defmodule Market.Accounts.User do
  @moduledoc false
  
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w[name email password]a

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    put_change(changeset, :password_hash, Argon2.add_hash(pass)[:password_hash])
  end

  defp put_pass_hash(changeset), do: changeset
end
