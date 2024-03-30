defmodule Demo.Repo.Migrations.AddCountFieldForUsersToRoles do
  use Ecto.Migration

  def change do
    alter table(:roles) do
      add :user_count, :integer, default: 0, null: false
    end
  end
end
