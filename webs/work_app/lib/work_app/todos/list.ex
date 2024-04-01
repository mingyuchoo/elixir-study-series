defmodule WorkApp.Todos.List do
  use Ecto.Schema
  import Ecto.Changeset

  alias WorkApp.Todos.{ListItem, Item}

  schema "lists" do
    field :title, :string
    many_to_many :items, Item, join_through: ListItem, on_replace: :delete
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title])
    |> cast_assoc(:items, required: true)
    |> validate_required([:title])
  end
end
