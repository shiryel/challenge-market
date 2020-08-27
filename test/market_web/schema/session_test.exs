defmodule MarketWeb.Schema.SessionTest do
  use MarketWeb.ConnCase, async: true

  alias Market.Accounts
  alias MarketWeb.Endpoint.Authentication

  describe "session" do
    @query """
    mutation ($email: String!, $password: String!) {
      login(email:$email, password:$password) {
        token
        user { name }
      }
    }
    """
    @user %{email: "dio@hotmail.com", password: "42", name: "jotaro"}

    test "creating an user session" do
      {:ok, user} = Accounts.create_user(@user)

      response =
        post(build_conn(), "/api", %{
          query: @query,
          variables: %{"email" => @user.email, "password" => @user.password}
        })

      assert %{
               "data" => %{
                 "login" => %{
                   "token" => token,
                   "user" => user_data
                 }
               }
             } = json_response(response, 200)

      assert %{"name" => user.name} == user_data

      assert {:ok, %{id: user.id}} == Authentication.verify(token)
    end
  end
end
