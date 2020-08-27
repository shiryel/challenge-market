defmodule MarketWeb.Endpoint.AuthenticationTest do
  use ExUnit.Case

  alias MarketWeb.Endpoint.Authentication

  describe "authentication" do
    token = Authentication.sign(%{id: 1})
    assert {:ok, %{id: 1}} == Authentication.verify(token)
  end
end
