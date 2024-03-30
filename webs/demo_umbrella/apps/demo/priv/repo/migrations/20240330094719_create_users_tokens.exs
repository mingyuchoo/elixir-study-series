defmodule Demo.Repo.Migrations.CreateUsersTokens do
  use Ecto.Migration

  def change do
    create table(:users_tokens) do
      add :token, :binary
      add :context, :string
      add :sent_to, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      
      timestamps()
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
