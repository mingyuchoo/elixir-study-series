defmodule WorkApp.Todos.ListItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias WorkApp.Todos.{List, Item}

  @primary_key false
  schema "lists_items" do
    belongs_to :list, List, primary_key: true
    belongs_to :item, Item, primary_key: true
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list_item, attrs) do
    list_item
    |> cast(attrs, [:list_id, :item_id])
    |> validate_required([:list_id, :item_id])
    |> foreign_key_constraint(:list_id)
    |> foreign_key_constraint(:item_id)
    |> unique_constraint([:list, :item],
      name: :list_id_item_id_unique_index,
      message: "ALREADY_EXISTS"
    )
  end
end
