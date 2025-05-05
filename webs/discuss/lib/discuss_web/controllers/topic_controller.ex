defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Repo
  alias Discuss.Topic
  import Ecto.Query, only: [from: 2]

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
      {:ok, topic} ->
        conn
        |> put_flash(:info, "\"#{topic.title}\" 토픽이 생성되었습니다.")
        |> redirect(to: ~p"/topics")

      {:error, changeset} ->
        render(conn, :new, layout: false, changeset: changeset)
    end
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    render(conn, :show, layout: false, topic: topic)
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    changeset = Topic.changeset(topic, %{})
    render(conn, :edit, layout: false, changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic_params}) do
    topic = Repo.get!(Topic, topic_id)
    changeset = Topic.changeset(topic, topic_params)

    case Repo.update(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "\"#{topic.title}\" 토픽이 업데이트되었습니다.")
        |> redirect(to: ~p"/topics")

      {:error, changeset} ->
        render(conn, :edit, layout: false, changeset: changeset, topic: topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    {:ok, _topic} = Repo.delete(topic)

    conn
    |> put_flash(:info, "토픽이 삭제되었습니다.")
    |> redirect(to: ~p"/topics")
  end
end
