# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Productivity.Repo.insert!(%Productivity.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Productivity.Works

[
  %{title: "Home", user_id: 1},
  %{title: "Office", user_id: 1},
  %{title: "Community", user_id: 1}
]
|> Enum.each(fn attr ->
  {:ok, _list} = Works.create_list(attr)
end)

[
  %{title: "Do laundry", description: "Given, When, Then", user_id: 1, list_id: 1},
  %{title: "Do refactoring code", description: "Given, When, Then", user_id: 1, list_id: 2},
  %{
    title: "Check post and add comments",
    description: "Given, When, Then",
    user_id: 1,
    list_id: 3
  }
]
|> Enum.each(fn attr ->
  {:ok, item} = Works.create_item(attr)
  {:ok, _} = Works.increase_item_count(item.list)
end)
