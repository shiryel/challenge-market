defmodule Market.BottlersTest do
  use Market.DataCase

  alias Market.Bottlers

  describe "providers" do
    alias Market.Bottlers.Provider

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def provider_fixture(attrs \\ %{}) do
      {:ok, provider} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bottlers.create_provider()

      provider
    end

    test "list_providers/0 returns all providers" do
      provider = provider_fixture()
      assert Bottlers.list_providers() == [provider]
    end

    test "get_provider!/1 returns the provider with given id" do
      provider = provider_fixture()
      assert Bottlers.get_provider!(provider.id) == provider
    end

    test "create_provider/1 with valid data creates a provider" do
      assert {:ok, %Provider{} = provider} = Bottlers.create_provider(@valid_attrs)
      assert provider.name == "some name"
    end

    test "create_provider/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bottlers.create_provider(@invalid_attrs)
    end

    test "update_provider/2 with valid data updates the provider" do
      provider = provider_fixture()
      assert {:ok, %Provider{} = provider} = Bottlers.update_provider(provider, @update_attrs)
      assert provider.name == "some updated name"
    end

    test "update_provider/2 with invalid data returns error changeset" do
      provider = provider_fixture()
      assert {:error, %Ecto.Changeset{}} = Bottlers.update_provider(provider, @invalid_attrs)
      assert provider == Bottlers.get_provider!(provider.id)
    end

    test "delete_provider/1 deletes the provider" do
      provider = provider_fixture()
      assert {:ok, %Provider{}} = Bottlers.delete_provider(provider)
      assert_raise Ecto.NoResultsError, fn -> Bottlers.get_provider!(provider.id) end
    end

    test "change_provider/1 returns a provider changeset" do
      provider = provider_fixture()
      assert %Ecto.Changeset{} = Bottlers.change_provider(provider)
    end
  end

  describe "pairs" do
    alias Market.Bottlers.Pair

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def pair_fixture(attrs \\ %{}) do
      {:ok, pair} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bottlers.create_pair()

      pair
    end

    test "list_pairs/0 returns all pairs" do
      pair = pair_fixture()
      assert Bottlers.list_pairs() == [pair]
    end

    test "get_pair!/1 returns the pair with given id" do
      pair = pair_fixture()
      assert Bottlers.get_pair!(pair.id) == pair
    end

    test "create_pair/1 with valid data creates a pair" do
      assert {:ok, %Pair{} = pair} = Bottlers.create_pair(@valid_attrs)
      assert pair.name == "some name"
    end

    test "create_pair/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bottlers.create_pair(@invalid_attrs)
    end

    test "update_pair/2 with valid data updates the pair" do
      pair = pair_fixture()
      assert {:ok, %Pair{} = pair} = Bottlers.update_pair(pair, @update_attrs)
      assert pair.name == "some updated name"
    end

    test "update_pair/2 with invalid data returns error changeset" do
      pair = pair_fixture()
      assert {:error, %Ecto.Changeset{}} = Bottlers.update_pair(pair, @invalid_attrs)
      assert pair == Bottlers.get_pair!(pair.id)
    end

    test "delete_pair/1 deletes the pair" do
      pair = pair_fixture()
      assert {:ok, %Pair{}} = Bottlers.delete_pair(pair)
      assert_raise Ecto.NoResultsError, fn -> Bottlers.get_pair!(pair.id) end
    end

    test "change_pair/1 returns a pair changeset" do
      pair = pair_fixture()
      assert %Ecto.Changeset{} = Bottlers.change_pair(pair)
    end
  end

  describe "bottlers" do
    alias Market.Bottlers.Bottler

    @valid_attrs %{date: ~N[2010-04-17 14:00:00], price: "120.5", quantity: 42}
    @update_attrs %{date: ~N[2011-05-18 15:01:01], price: "456.7", quantity: 43}
    @invalid_attrs %{date: nil, price: nil, quantity: nil}

    def bottler_fixture(attrs \\ %{}) do
      {:ok, bottler} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bottlers.create_bottler()

      bottler
    end

    test "list_bottlers/0 returns all bottlers" do
      bottler = bottler_fixture()
      assert Bottlers.list_bottlers() == [bottler]
    end

    test "get_bottler!/1 returns the bottler with given id" do
      bottler = bottler_fixture()
      assert Bottlers.get_bottler!(bottler.id) == bottler
    end

    test "create_bottler/1 with valid data creates a bottler" do
      assert {:ok, %Bottler{} = bottler} = Bottlers.create_bottler(@valid_attrs)
      assert bottler.date == ~N[2010-04-17 14:00:00]
      assert bottler.price == Decimal.new("120.5")
      assert bottler.quantity == 42
    end

    test "create_bottler/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bottlers.create_bottler(@invalid_attrs)
    end

    test "update_bottler/2 with valid data updates the bottler" do
      bottler = bottler_fixture()
      assert {:ok, %Bottler{} = bottler} = Bottlers.update_bottler(bottler, @update_attrs)
      assert bottler.date == ~N[2011-05-18 15:01:01]
      assert bottler.price == Decimal.new("456.7")
      assert bottler.quantity == 43
    end

    test "update_bottler/2 with invalid data returns error changeset" do
      bottler = bottler_fixture()
      assert {:error, %Ecto.Changeset{}} = Bottlers.update_bottler(bottler, @invalid_attrs)
      assert bottler == Bottlers.get_bottler!(bottler.id)
    end

    test "delete_bottler/1 deletes the bottler" do
      bottler = bottler_fixture()
      assert {:ok, %Bottler{}} = Bottlers.delete_bottler(bottler)
      assert_raise Ecto.NoResultsError, fn -> Bottlers.get_bottler!(bottler.id) end
    end

    test "change_bottler/1 returns a bottler changeset" do
      bottler = bottler_fixture()
      assert %Ecto.Changeset{} = Bottlers.change_bottler(bottler)
    end
  end
end
