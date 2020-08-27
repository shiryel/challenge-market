defmodule MarketWeb.Resolver.Utils do
  @moduledoc """
  Functions to parse internal data in the resolvers
  """

  @typedoc """
  The type of the %Ecto.Changeset{} when parsed by `transform_errors/1`
  """
  @type changeset_error :: [%{key: :string, message: any}]

  @doc """
  Transform a error changeset to a error in Absinthe
  """
  @spec transform_errors(%Ecto.Changeset{}) :: changeset_error()
  def transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&translate_error/1)
    |> Enum.map(fn {key, value} ->
      %{key: key, message: value}
    end)
  end

  @doc """
  Translates an error message.
  """
  def translate_error({msg, opts}) do
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
