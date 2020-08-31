defmodule Market.Bottlers do
  @moduledoc """
  The Bottlers context.
  """

  import Ecto.Query, warn: false
  alias Market.Repo

  ##############
  # DATALOADER #
  ##############

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(__MODULE__.Bottler = struct, args) do
    Enum.reduce(args, struct, fn
      {:filter, filter}, query ->
        bottler_filter_query(query, filter)

      _, query ->
        query
    end)
    |> pagination_query(args)
  end

  def query(__MODULE__.Pair = struct, args) do
    struct
    |> filter_names_query(args)
    |> pagination_query(args)
  end

  #######################
  # GENERAL COMPOSITION #
  #######################

  defp pagination_query(struct, args) do
    # default page size
    struct =
      struct
      |> limit(50)

    Enum.reduce(args, struct, fn
      {:page_id, page}, query ->
        query |> offset(^page - 1)

      {:page_size, page_size}, query ->
        # page size limit
        if page_size <= 50 do
          query |> limit(^page_size)
        else
          query
        end

      _, query ->
        query
    end)
  end

  defp filter_names_query(struct, args) do
    Enum.reduce(args, struct, fn
      {:filter_names, names}, query ->
        from x in query, where: x.name in ^names

      _, query ->
        query
    end)
  end

  defp bottler_filter_query(struct, args) do
    Enum.reduce(args, struct, fn
      {:price_min, price_min}, query ->
        from b in query, where: b.price >= ^price_min

      {:price_max, price_max}, query ->
        from b in query, where: b.price <= ^price_max

      {:quantity_min, quantity_min}, query ->
        from b in query, where: b.quantity >= ^quantity_min

      {:quantity_max, quantity_max}, query ->
        from b in query, where: b.quantity <= ^quantity_max

      {:date_start, date_min}, query ->
        from b in query, where: b.date >= ^date_min

      {:date_end, date_max}, query ->
        from b in query, where: b.date <= ^date_max
    end)
  end

  ############
  # PROVIDER #
  ############

  alias Market.Bottlers.Provider

  @doc """
  Returns the list of providers.

  ## Examples

      iex> list_providers()
      [%Provider{}, ...]

  """
  def list_providers do
    Repo.all(Provider)
  end

  def list_providers(args) do
    pagination_query(Provider, args)
    |> filter_names_query(args)
    |> Repo.all()
  end

  @doc """
  Gets a single provider.

  Raises `Ecto.NoResultsError` if the Provider does not exist.

  ## Examples

      iex> get_provider!(123)
      %Provider{}

      iex> get_provider!(456)
      ** (Ecto.NoResultsError)

  """
  def get_provider!(id), do: Repo.get!(Provider, id)

  @doc """
  Creates a provider.

  ## Examples

      iex> create_provider(%{field: value})
      {:ok, %Provider{}}

      iex> create_provider(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_provider(attrs \\ %{}) do
    %Provider{}
    |> Provider.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a provider.

  ## Examples

      iex> update_provider(provider, %{field: new_value})
      {:ok, %Provider{}}

      iex> update_provider(provider, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_provider(%Provider{} = provider, attrs) do
    provider
    |> Provider.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a provider.

  ## Examples

      iex> delete_provider(provider)
      {:ok, %Provider{}}

      iex> delete_provider(provider)
      {:error, %Ecto.Changeset{}}

  """
  def delete_provider(%Provider{} = provider) do
    Repo.delete(provider)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking provider changes.

  ## Examples

      iex> change_provider(provider)
      %Ecto.Changeset{data: %Provider{}}

  """
  def change_provider(%Provider{} = provider, attrs \\ %{}) do
    Provider.changeset(provider, attrs)
  end

  ########
  # PAIR #
  ########

  alias Market.Bottlers.Pair

  @doc """
  Returns the list of pairs.

  ## Examples

      iex> list_pairs()
      [%Pair{}, ...]

  """
  def list_pairs do
    Repo.all(Pair)
  end

  @doc """
  Gets a single pair.

  Raises `Ecto.NoResultsError` if the Pair does not exist.

  ## Examples

      iex> get_pair!(123)
      %Pair{}

      iex> get_pair!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pair!(id), do: Repo.get!(Pair, id)

  @doc """
  Creates a pair.

  ## Examples

      iex> create_pair(%{field: value})
      {:ok, %Pair{}}

      iex> create_pair(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pair(attrs \\ %{}) do
    %Pair{}
    |> Pair.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pair.

  ## Examples

      iex> update_pair(pair, %{field: new_value})
      {:ok, %Pair{}}

      iex> update_pair(pair, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pair(%Pair{} = pair, attrs) do
    pair
    |> Pair.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pair.

  ## Examples

      iex> delete_pair(pair)
      {:ok, %Pair{}}

      iex> delete_pair(pair)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pair(%Pair{} = pair) do
    Repo.delete(pair)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pair changes.

  ## Examples

      iex> change_pair(pair)
      %Ecto.Changeset{data: %Pair{}}

  """
  def change_pair(%Pair{} = pair, attrs \\ %{}) do
    Pair.changeset(pair, attrs)
  end

  ###########
  # BOTTLER #
  ###########

  alias Market.Bottlers.Bottler

  @doc """
  Returns the list of bottlers.

  ## Examples

      iex> list_bottlers()
      [%Bottler{}, ...]

  """
  def list_bottlers do
    Repo.all(Bottler)
  end

  @doc """
  Gets a single bottler.

  Raises `Ecto.NoResultsError` if the Bottler does not exist.

  ## Examples

      iex> get_bottler!(123)
      %Bottler{}

      iex> get_bottler!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bottler!(id), do: Repo.get!(Bottler, id)

  @doc """
  Creates a bottler.

  ## Examples

      iex> create_bottler(%{field: value})
      {:ok, %Bottler{}}

      iex> create_bottler(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bottler(attrs \\ %{}) do
    %Bottler{}
    |> Bottler.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bottler.

  ## Examples

      iex> update_bottler(bottler, %{field: new_value})
      {:ok, %Bottler{}}

      iex> update_bottler(bottler, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bottler(%Bottler{} = bottler, attrs) do
    bottler
    |> Bottler.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bottler.

  ## Examples

      iex> delete_bottler(bottler)
      {:ok, %Bottler{}}

      iex> delete_bottler(bottler)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bottler(%Bottler{} = bottler) do
    Repo.delete(bottler)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bottler changes.

  ## Examples

      iex> change_bottler(bottler)
      %Ecto.Changeset{data: %Bottler{}}

  """
  def change_bottler(%Bottler{} = bottler, attrs \\ %{}) do
    Bottler.changeset(bottler, attrs)
  end
end
