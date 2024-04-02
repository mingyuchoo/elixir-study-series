# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Demo.Repo.insert!(%Demo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Demo.Repo
alias Demo.Accounts.{Role}
Repo.insert!(%Role{name: "Appr", description: "Apprentice"})
Repo.insert!(%Role{name: "Dev", description: "Developer"})
Repo.insert!(%Role{name: "Op", description: "Operator"})
Repo.insert!(%Role{name: "QA", description: "Quality Assurance"})
Repo.insert!(%Role{name: "Aud", description: "Aduditor"})
Repo.insert!(%Role{name: "Admin", description: "Administrator"})
