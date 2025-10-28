defmodule Productivity.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists, prefix: :productivity) do
      add :title, :string
      add :item_count, :integer, null: false, default: 0

      add :user_id, references(:users, prefix: :playa, on_delete: :nilify_all), null: true

      timestamps(type: :utc_datetime)
    end
  end
end
