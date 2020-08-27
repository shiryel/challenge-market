defmodule MarketWeb.Endpoint.Authentication do
  @moduledoc """
    Used by `Jungsoft.Resolver.login/3` to create a token and `JungsoftWeb.Context` to validate the token and add the user to the context
  """

  @doc """
  Will gen a new token with the data
  """
  @spec sign(map()) :: bitstring()
  def sign(data) do
    user_salt = Application.get_env(:market, :user_salt)

    Phoenix.Token.sign(MarketWeb.Endpoint, user_salt, data)
  end

  @doc """
  With the token generated on `sign/1`, verify it, and get the data back
  """
  @spec verify(bitstring()) :: {:error, :expired | :invalid | :missing} | {:ok, map()}
  def verify(token) do
    user_salt = Application.get_env(:market, :user_salt)

    Phoenix.Token.verify(MarketWeb.Endpoint, user_salt, token, max_age: 24 * 3600) # 1 day
  end
end
