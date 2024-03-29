defmodule Demo.Repo.Migrations.AddFieldToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :role, :string
      add :address, :string
    end

    create unique_index(:users, [:email])
  end
end
