defmodule WorkApp.Todos.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias WorkApp.Todos.{List, ListItem}

  schema "items" do
    field :description, :string
    many_to_many :lists, List, join_through: ListItem, on_replace: :delete
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:description])
    |> cast_assoc(:lists, required: true)
    |> validate_required([:description])
  end
end
