defmodule WorkApp.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string
      timestamps(type: :utc_datetime)
    end
  end
end
