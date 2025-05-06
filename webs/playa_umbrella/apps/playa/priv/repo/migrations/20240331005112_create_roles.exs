defmodule Playa.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles, prefix: :playa) do
      add :name, :string, null: false
      add :description, :string
      add :user_count, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create unique_index(:roles, [:name], prefix: :playa)
  end
end
