defmodule Productivity.Works.List do
  use Ecto.Schema
  import Ecto.Changeset

  alias Playa.Accounts.User
  alias Productivity.Works.Item

  @schema_prefix :productivity
  schema "lists" do
    field :title, :string
    field :item_count, :integer, default: 0

    belongs_to :user, User, on_replace: :delete

    has_many :items, Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    # NOTE:
    # changeset 함수 내에서 put_assoc을 사용하지 않고,
    # belongs_to 관계에서 user_id 필드만 업데이트함
    # user_id로 관계를 관리하면 put_assoc을 사용하는 것보다
    # 데이터 관리가 더 명확해짐
    list
    |> cast(attrs, [:title, :item_count, :user_id])
    |> validate_required([:title, :user_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:items)
  end
end
