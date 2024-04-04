defmodule Demo.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :item_id, :id, primary_key: true
      add :item_title, :string

      add :list_id,
          references(:lists, column: :list_id, type: :id, on_delete: :delete_all, type: :id)

      timestamps(type: :utc_datetime)
    end

    create index(:items, [:list_id])
  end
end
