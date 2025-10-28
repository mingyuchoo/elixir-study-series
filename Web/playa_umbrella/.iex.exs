import Ecto.Query
import Ecto.Changeset

alias Playa.Repo

alias Playa.Accounts
alias Playa.Accounts.{Role, User, RoleUser}

alias Productivity.Works
alias Productivity.Works.{List, Item}

alias Productivity.ActivityLog
alias Productivity.ActivityLog.Entry

list = %List{}
item = %Item{}
