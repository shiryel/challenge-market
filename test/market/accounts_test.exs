defmodule Market.AccountsTest do
  use Market.DataCase

  alias Market.Accounts

  describe "users" do
    alias Accounts.User

    @valid_attrs %{email: "some email", password: "some hash_password", name: "some name"}
    @update_attrs %{
      email: "some updated email",
      password: "some updated hash_password",
      name: "some updated name"
    }
    @invalid_attrs %{email: nil, password: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
      |> Map.put(:password, nil)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user(user.id) == user
    end

    test "get_user_by_email/1 returns the user with given email" do
      user = user_fixture()
      assert Accounts.get_user_by_email(user.email) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert is_bitstring(user.password_hash)
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert is_bitstring(user.password_hash)
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert nil == Accounts.get_user(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "authenticate/2 returns if the user exists and if is authenticated" do
      user = user_fixture()
      assert {:ok, user} == Accounts.authenticate(@valid_attrs.email, @valid_attrs.password)
    end

    test "authenticate/2 returns a error not found if user dont exists" do
      user_fixture()
      assert {:error, "not found"} == Accounts.authenticate("invalid email", @valid_attrs.password)
    end

    test "authenticate/2 returns a error invalid password if user exists but password is incorrect" do
      user_fixture()
      assert {:error, "invalid password"} == Accounts.authenticate(@valid_attrs.email, "invalid password")
    end
  end
end
