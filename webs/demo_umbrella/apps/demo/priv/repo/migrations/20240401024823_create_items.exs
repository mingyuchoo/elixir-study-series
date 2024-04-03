defmodule Demo.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :list_id, references(:lists, on_delete: :nothing)
      timestamps(type: :utc_datetime)
    end

    create index(:items, [:list_id])
  end
end
