defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic

  def index(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, :index, layout: false)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, post} -> IO.inspect(post)
      {:error, changeset} -> render(conn, :index, layout: false)
    end
  end
end
