defmodule Demo.Todos.List do
  use Ecto.Schema
  import Ecto.Changeset

  alias Demo.Todos.Item

  schema "lists" do
    field :title, :string
    field :item_count, :integer, default: 0

    has_many :items, Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :item_count])
    |> validate_required([:title])
  end
end
