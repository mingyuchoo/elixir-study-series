defmodule Productivity.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, prefix: :productivity) do
      add :title, :string
      add :description, :string, null: true
      add :status, :string

      add :user_id, references(:users, prefix: :playa, on_delete: :nilify_all), null: true
      add :list_id, references(:lists, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:items, [:list_id], prefix: :productivity)
  end
end
