defmodule WorkApp.Repo.Migrations.CreateListsItems do
  use Ecto.Migration

  def change do
    create table(:lists_items, primary_key: false) do
      add :list_id, references(:lists, on_delete: :delete_all), primary_key: true
      add :item_id, references(:items, on_delete: :delete_all), primary_key: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:lists_items, [:list_id, :item_id], name: :list_id_item_id_unique_index)
  end
end
