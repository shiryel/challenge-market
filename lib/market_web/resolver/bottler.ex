defmodule MarketWeb.Resolver.Bottler do
  @moduledoc """
  Functions to resolve the Bottler context
  """

  alias Market.Bottlers

  def list_providers(_root, args, _context) do
    {:ok, Bottlers.list_providers(args)}
  end
end
