# Script for populating the database. You can run it as:
#
#      mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#      Playa.Repo.insert!(%Playa.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Playa.Accounts

# Roles
[
  %{name: "Appr", description: "Apprentice"},
  %{name: "Dev", description: "Developer"},
  %{name: "Op", description: "Operator"},
  %{name: "QA", description: "Quality Assurance"},
  %{name: "Aud", description: "Auditor"},
  %{name: "Admin", description: "Administrator"}
]
|> Enum.each(fn attr ->
  {:ok, _role} = Accounts.create_role(attr)
end)

# Users
[
  %{email: "ghost@email.com", password: "qwe123QWE!@#", nickname: "Ghost", role_id: 1}
]
|> Enum.each(fn attr ->
  {:ok, user} = Accounts.register_user(attr)
  Enum.map(user.roles, fn role -> Accounts.increase_user_count(role) end)
end)
