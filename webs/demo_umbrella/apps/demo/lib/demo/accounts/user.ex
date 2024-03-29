defmodule Demo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Demo.Accounts.Role

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    field :address, :string

    # 추가
    belongs_to :role, Role

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age, :email, :address, :role_id]) # 수정
    |> validate_required([:name, :age, :email, :address, :role_id]) # 수정
    |> assoc_constraint(:role) # 추가
    |> unique_constraint(:email)
  end
end
