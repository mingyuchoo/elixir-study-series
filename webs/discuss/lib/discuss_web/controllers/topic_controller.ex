defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Repo
  alias Discuss.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic)

    render(conn, :index, layout: false, topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, :new, layout: false, changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic Created")

      {:error, changeset} ->
        render(conn, :index, layout: false)
    end
  end
end
