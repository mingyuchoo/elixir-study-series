defmodule Productivity.Repo.Migrations.CreateListsItems do
  use Ecto.Migration

  def change do
    # NOTE:
    # Ecto에서는 복합 기본 키를 직접 지원하지 않아
    # primary_key: false 옵션을 사용할 수 없음
    create table(:lists_items, prefix: :productivity) do
      add :list_id, references(:lists, on_delete: :delete_all), null: false
      add :item_id, references(:items, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    # NOTE:
    # PK는 id 컬럼이지만 :role_id, :user_id를 UK로 만들어
    # PK 효과를 내도록 함
    create unique_index(:lists_items, [:list_id, :item_id], prefix: :productivity)
  end
end
