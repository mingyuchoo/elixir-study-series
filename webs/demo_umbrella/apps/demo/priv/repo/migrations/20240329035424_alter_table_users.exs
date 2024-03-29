defmodule Demo.Repo.Migrations.AlterTableUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :role
      add :role_id, references(:roles)
    end
  end
end
