defmodule MarketWeb.Schema do
  @moduledoc """
  Absinthe GraphQL Schema
  """

  use Absinthe.Schema
  alias MarketWeb.Resolver.Session

  import_types(__MODULE__.User)
  import_types(__MODULE__.Session)

  object :me_queries do
    import_fields(:user)
  end

  object :me_mutations do
  end

  ################
  # ENTRY POINTS #
  ################

  query do
    @desc """
    Generate a context based on the token from the login
    NOTE: You need to use the HTTP Header "Authorization" with "Bearer {token}" from the mutation login(email, password) !!!
    """
    field :me, :me_queries do
      resolve(&Session.me/3)
    end
  end

  mutation do
    # :session_mutations needs to be out of the :me
    # to be able to work without a authentication dann~
    import_fields(:session_mutations)
  end
end
