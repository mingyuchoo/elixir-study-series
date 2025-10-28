defmodule Playa.Repo.Migrations.CreateSchema do
  use Ecto.Migration

  def up do
    execute "CREATE SCHEMA IF NOT EXISTS playa"
  end

  def down do
    execute "DROP SCHEMA IF EXISTS playa"
  end
end
