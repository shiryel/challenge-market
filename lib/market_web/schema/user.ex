defmodule MarketWeb.Schema.User do
  @moduledoc false

  use Absinthe.Schema.Notation

  @desc "User info, get from the authentication"
  object :user do
    @desc "User name"
    field :name, :string
    @desc "User email, used on login"
    field :email, :string
  end
end
