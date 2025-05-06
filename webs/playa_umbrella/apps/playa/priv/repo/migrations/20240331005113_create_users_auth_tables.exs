defmodule Playa.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, prefix: :playa) do
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :nickname, :string
      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email], prefix: :playa)

    create table(:users_tokens, prefix: :playa) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id], prefix: :playa)
    create unique_index(:users_tokens, [:context, :token], prefix: :playa)
  end
end
