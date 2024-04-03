defmodule Demo.Todos.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Demo.Todos.List

  schema "items" do
    field :title, :string

    belongs_to :list, List

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :list_id])
    |> validate_required([:title, :list_id])
  end
end
