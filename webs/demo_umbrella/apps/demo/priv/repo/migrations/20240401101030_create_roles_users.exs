defmodule Demo.Repo.Migrations.CreateRolesUsers do
  use Ecto.Migration

  def change do
    create table(:roles_users, primary_key: false) do
      add :role_id, references(:roles, on_delete: :delete_all), primary_key: true
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      timestamps()
    end

    create unique_index(:roles_users, [:role_id, :user_id], name: :role_id_user_id_unique_index)
  end
end
