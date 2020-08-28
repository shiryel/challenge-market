defmodule Market.Bottlers.Pair do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w[name]a

  schema "pairs" do
    field :name, :string

    belongs_to :provider, Market.Bottlers.Provider
    has_many :bottlers, Market.Bottlers.Bottler

    timestamps()
  end

  @doc false
  def changeset(pair, attrs) do
    pair
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
