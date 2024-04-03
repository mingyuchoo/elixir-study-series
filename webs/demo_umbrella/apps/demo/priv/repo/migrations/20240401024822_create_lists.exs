defmodule Demo.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string
      add :item_count, :integer, null: false, default: 0
      timestamps(type: :utc_datetime)
    end
  end
end
