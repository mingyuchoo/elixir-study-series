defmodule Productivity.ActivityLog do
  @moduledoc """
  The ActivityLog context.
  """

  import Ecto.Query, warn: false

  alias Productivity.{Repo, Scope}
  alias Productivity.ActivityLog.Entry
  alias Productivity.Works.{List, Item}

  def log(%Scope{} = scope, %List{} = list, %{} = attrs) do
    id = if list.__meta__.state == :deleted, do: nil, else: list.id

    %Entry{user_id: scope.current_user_id, list_id: id}
    |> Entry.changeset(attrs)
    |> Repo.insert!()
  end

  def log(%Scope{} = scope, %Item{} = item, %{} = attrs) do
    id = if item.__meta__.state == :deleted, do: nil, else: item.id

    %Entry{user_id: scope.current_user_id, list_id: item.list_id, item_id: id}
    |> Entry.changeset(attrs)
    |> Repo.insert!()
  end
end
