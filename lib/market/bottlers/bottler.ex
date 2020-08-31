defmodule Market.Bottlers.Bottler do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w[price quantity date]a

  schema "bottlers" do
    field :price, :decimal
    field :quantity, :integer
    field :date, :utc_datetime

    belongs_to :pair, Market.Bottlers.Pair

    timestamps()
  end

  @doc false
  def changeset(bottler, attrs) do
    bottler
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
