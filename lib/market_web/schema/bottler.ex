defmodule MarketWeb.Schema.Bottler do
  @moduledoc false

  use Absinthe.Schema.Notation

  alias MarketWeb.Resolver.Bottler

  object :bottler do
    field :price, :decimal
    field :quantity, :integer
    field :date, :naive_datetime
  end

  object :pair do
    field :name, :string

    field :bottlers, list_of(:bottler) do
      arg(:price_min, :decimal)
      arg(:price_max, :decimal)
      arg(:quantity_min, :integer)
      arg(:quantity_max, :integer)
      arg(:date_start, :naive_datetime)
      arg(:date_end, :naive_datetime)
      resolve &Bottler.list_bottlers/3
    end
  end

  object :provider do
    field :name, :string

    field :pairs, list_of(:pair) do
      arg(:filter, list_of(:string))
      resolve &Bottler.list_pairs/3
    end
  end

  # QUERIE
  object :bottler_queries do
    field :providers, list_of(:provider) do
      arg(:filter, list_of(:string))
      resolve &Bottler.list_providers/3
    end
  end
end
