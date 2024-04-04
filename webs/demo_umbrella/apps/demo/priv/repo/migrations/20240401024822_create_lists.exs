defmodule Demo.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists, primary_key: false) do
      add :list_id, :id, primary_key: true
      add :list_title, :string
      add :list_item_count, :integer, null: false, default: 0
      timestamps(type: :utc_datetime)
    end
  end
end
