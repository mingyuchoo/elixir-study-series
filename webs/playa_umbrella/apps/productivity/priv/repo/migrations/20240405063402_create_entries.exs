defmodule Productivity.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries, prefix: :productivity) do
      add :action, :string

      add :user_id, references(:users, prefix: :playa, on_delete: :nilify_all), null: true
      add :list_id, references(:lists, on_delete: :nilify_all), null: true
      add :item_id, references(:items, on_delete: :nilify_all), null: true

      timestamps()
    end

    create index(:entries, [:list_id], prefix: :productivity)
    create index(:entries, [:item_id], prefix: :productivity)
  end
end
