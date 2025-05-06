defmodule Playa.Accounts.RoleUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias Playa.Accounts.{Role, User}

  @schema_prefix :playa
  schema "roles_users" do
    belongs_to :role, Role, primary_key: true
    belongs_to :user, User, primary_key: true
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role_user, attrs) do
    role_user
    |> cast(attrs, [:role_id, :user_id])
    |> validate_required([:role_id, :user_id])
    |> foreign_key_constraint(:role_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:role, :user],
      name: :role_id_user_id_unique_index,
      message: "ALREADY_EXISTS"
    )
  end
end
