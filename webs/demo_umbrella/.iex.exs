alias Demo.Repo

alias Demo.Todos
alias Demo.Todos.{List, Item}

attrs = %{"title" => "Hello", "list_id" => "1"}
item_changeset = Ecto.Changeset.cast(%Item{}, attrs, [:title])
