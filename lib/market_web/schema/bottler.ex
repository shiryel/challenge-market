defmodule MarketWeb.Schema.Bottler do
  @moduledoc false

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Market.Bottlers
  alias MarketWeb.Resolver

  object :bottler do
    field :price, :decimal
    field :quantity, :integer
    field :date, :datetime
  end

  input_object :bottler_filter do
    field :price_min, :decimal
    field :price_max, :decimal
    field :quantity_min, :integer
    field :quantity_max, :integer
    field :date_start, :datetime
    field :date_end, :datetime
  end

  object :pair do
    field :name, :string
    field :bottlers, list_of(:bottler) do
      arg :filter, non_null(:bottler_filter)
      arg(:page, :integer)
      arg(:page_size, :integer)
      resolve(dataloader(Bottlers))
    end
  end

  object :provider do
    field :name, :string
    field :pairs, list_of(:pair) do
      arg(:filter_names, list_of(:string))
      arg(:page, :integer)
      arg(:page_size, :integer)
      resolve(dataloader(Bottlers))
    end
  end

  # QUERIE
  object :bottler_queries do
    field :providers, list_of(:provider) do
      arg(:filter_names, list_of(:string))
      arg(:page, :integer)
      arg(:page_size, :integer)
      resolve(&Resolver.Bottler.list_providers/3)
    end
  end
end
