defmodule Demo.Todos.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Demo.Todos.List

  @primary_key {:item_id, :id, autogenerate: true}
  schema "items" do
    field :item_title, :string

    belongs_to :list, List

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:item_title, :list_id])
    |> validate_required([:item_title, :list_id])
  end
end
