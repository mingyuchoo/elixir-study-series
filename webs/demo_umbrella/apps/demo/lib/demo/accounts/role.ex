defmodule Demo.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias Demo.Accounts.User

  schema "roles" do
    field :name, :string
    field :description, :string
    field :user_count, :integer
    
    # 추가
    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description, :user_count])
    |> validate_required([:name, :description])
  end
end
