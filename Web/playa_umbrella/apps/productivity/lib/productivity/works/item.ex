defmodule Productivity.Works.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Playa.Accounts.User
  alias Productivity.Works.List

  @schema_prefix :productivity
  schema "items" do
    field :title, :string
    field :description, :string
    field :status, Ecto.Enum, values: [:todo, :doing, :done], default: :todo

    belongs_to :user, User, on_replace: :delete
    belongs_to :list, List

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    # NOTE:
    # changeset 함수 내에서 put_assoc을 사용하지 않고,
    # belongs_to 관계에서 user_id 필드만 업데이트함
    # user_id로 관계를 관리하면 put_assoc을 사용하는 것보다
    # 데이터 관리가 더 명확해짐
    item
    |> cast(attrs, [:title, :description, :status, :user_id, :list_id])
    |> validate_required([:title, :description, :status, :user_id, :list_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:list)
  end

  def status_values do
    [:todo, :doing, :done]
  end
end
