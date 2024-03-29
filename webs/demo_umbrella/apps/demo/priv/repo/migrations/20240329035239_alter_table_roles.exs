defmodule Demo.Repo.Migrations.AlterTableRoles do
  use Ecto.Migration

  def change do
    alter table(:roles) do
      add :description, :string
    end
  end
end
