alias Demo.Repo
alias Demo.Accounts
alias Demo.Accounts.{Role, RoleUser, User}

user = %User{}

attrs = %{
  "email" => "mingyuchoo@gmail.com",
  "nickname" => "Choo",
  "password" => "qwe123QWE!@#",
  "role_id" => "1"
}

user_pre = Repo.preload(user, :roles)
user_changeset = Ecto.Changeset.cast(user_pre, attrs, [:email, :password])
