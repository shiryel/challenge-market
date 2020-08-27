defmodule MarketWeb.Endpoint.Context do
  @moduledoc """
  Plug to make the Absinthe schema context
  Populates the context with the `%{current_user: %User{...}}` info
  """

  alias Market.Accounts
  alias MarketWeb.Endpoint.Authentication
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, data} <- Authentication.verify(token),
         %{} = user <- get_user(data) do
      %{current_user: user}
    else
      _ ->
        %{}
    end
  end

  defp get_user(%{id: id}) do
    Accounts.get_user(id)
  end
end
