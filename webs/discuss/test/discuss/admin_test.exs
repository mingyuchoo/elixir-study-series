defmodule Discuss.AdminTest do
  use Discuss.DataCase

  alias Discuss.Admin

  describe "users" do
    alias Discuss.Admin.User

    import Discuss.AdminFixtures

    @invalid_attrs %{address: nil, email: nil, name: nil, role: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Admin.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Admin.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{address: "some address", email: "some email", name: "some name", role: "some role"}

      assert {:ok, %User{} = user} = Admin.create_user(valid_attrs)
      assert user.address == "some address"
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.role == "some role"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{address: "some updated address", email: "some updated email", name: "some updated name", role: "some updated role"}

      assert {:ok, %User{} = user} = Admin.update_user(user, update_attrs)
      assert user.address == "some updated address"
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.role == "some updated role"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_user(user, @invalid_attrs)
      assert user == Admin.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Admin.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Admin.change_user(user)
    end
  end
end
