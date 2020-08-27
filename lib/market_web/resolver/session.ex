defmodule MarketWeb.Resolver.Session do
  @moduledoc """
  Handle session informations, like sign the token and verifying if the context was a user through the me entry point
  """
  alias Market.Accounts
  alias Accounts.User

  @doc """
  Verify the email and password, gen a token with `Jungsoft.Authentication.sign/1` and send in the API
  With the token, the client can pass a HTTP Header "Authorization" with "Bearer {token}", that will be used by the `Jungsoft.Context` plug in the endpoint to fill the context for others mutations (the plug need the user ID of the token)
  """
  @spec login(any, %{email: :string, password: :string}, any) ::
          {:error, bitstring()} | {:ok, %{token: :string}, user: %User{}}
  def login(_root, %{email: email, password: password}, _info) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        token =
          MarketWeb.Endpoint.Authentication.sign(%{
            id: user.id
          })

        {:ok, %{token: token, user: user}}

      {:error, error_str} ->
        # will be "not found" or "invalid password"
        {:error, error_str}
    end
  end

  @doc """
  Verify if the context have %{current_user: %User{}}
  """
  @spec me(any, any, any) :: {:ok, %User{}} | {:error, nil}
  def me(_root, _attrs, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def me(_root, _attrs, _info) do
    {:error, "invalid token"}
  end
end
