defmodule Demo.Todos.List do
  use Ecto.Schema
  import Ecto.Changeset

  alias Demo.Todos.Item

  @primary_key {:list_id, :id, autogenerate: true}
  schema "lists" do
    field :list_title, :string
    field :list_item_count, :integer, default: 0

    has_many :items, Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:list_title, :list_item_count])
    |> validate_required([:list_title])
    |> foreign_key_constraint(:items)
  end
end
