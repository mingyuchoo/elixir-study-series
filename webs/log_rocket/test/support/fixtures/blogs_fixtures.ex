defmodule LogRocket.BlogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LogRocket.Blogs` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> LogRocket.Blogs.create_post()

    post
  end
end
