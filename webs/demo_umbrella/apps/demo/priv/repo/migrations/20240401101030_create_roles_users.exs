defmodule Demo.Repo.Migrations.CreateRolesUsers do
  use Ecto.Migration

  def change do
    create table(:roles_users) do
      add :role_id, references(:roles, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:roles_users, [:role_id, :user_id])
  end
end
