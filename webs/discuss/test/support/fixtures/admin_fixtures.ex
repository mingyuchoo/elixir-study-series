defmodule Discuss.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Discuss.Admin` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        address: "some address",
        email: unique_user_email(),
        name: "some name",
        role: "some role"
      })
      |> Discuss.Admin.create_user()

    user
  end
end
