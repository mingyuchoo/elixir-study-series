defmodule Productivity.Repo.Migrations.CreateSchema do
  use Ecto.Migration

  def up do
    execute "CREATE SCHEMA IF NOT EXISTS productivity"
  end

  def down do
    execute "DROP SCHEMA IF EXISTS productivity"
  end
end
