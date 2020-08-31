defmodule Market.Bottlers.Provider do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w[name]a

  schema "providers" do
    field :name, :string

    has_many :pairs, Market.Bottlers.Pair

    timestamps()
  end

  @doc false
  def changeset(provider, attrs) do
    provider
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
