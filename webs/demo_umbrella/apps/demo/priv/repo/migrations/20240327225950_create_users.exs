defmodule Demo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""
    
    create table(:users) do
      add :email, :citext, null: false
      add :password, :string, virtual: true, redact: true
      add :hashed_password, :string, redact: true
      add :nickname, :string
      add :confirmed_at, :naive_datetime
      add :role_id, references(:roles, on_delete: :nilify_all), null: false
      
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
