defmodule WorkApp.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WorkApp.Todos` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> WorkApp.Todos.create_list()

    list
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        description: "some description"
      })
      |> WorkApp.Todos.create_item()

    item
  end
end
