defmodule Playa.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Playa.Repo

  alias Playa.Accounts.{Role, User, RoleUser, UserToken, UserNotifier}

  # ---------------------------------------------------------------------------

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
    |> Repo.preload(:roles)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    # NOTE:
    # 연관 데이터가 있어 preload 함
    Repo.get!(User, id)
    |> Repo.preload(:roles)
  end

  ## User registration

  @doc """
  Registers a user.
  # NOTE:
  사용자를 생성한 뒤 연관된 데이터를 preload하지 않으면
  방금 생성한 사용자에 연관된 데이터가 없어
  목록에 생성한 사용자를 보여주고자 할 때 오류가 발생함
  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
    # IMPORTANT:
    |> case do
      {:ok, user} -> {:ok, Repo.preload(user, :roles)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def is_admin?(%User{} = user) do
    Enum.any?(user.roles, fn role -> role.name == "Admin" end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    user
    |> Repo.preload(:roles)
    |> User.registration_changeset(attrs, hash_password: false, validate_email: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs, validate_email: false)
  end

  def change_user_nickname(user, attrs \\ %{}) do
    User.nickname_changeset(user, attrs)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset =
      user
      |> User.email_changeset(%{email: email})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, [context]))
  end

  @doc ~S"""
  Delivers the update email instructions to the given user.

  ## Examples

      iex> deliver_user_update_email_instructions(user, current_email, &url(~p"/users/settings/confirm_email/#{&1})")
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc ~S"""
  Delivers the confirmation email instructions to the given user.

  ## Examples

      iex> deliver_user_confirmation_instructions(user, &url(~p"/users/confirm/#{&1}"))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &url(~p"/users/confirm/#{&1}"))
      {:error, :already_confirmed}

  """
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc ~S"""
  Delivers the reset password email to the given user.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &url(~p"/users/reset_password/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  # ---------------------------------------------------------------------------
  # User
  # ---------------------------------------------------------------------------

  def list_users do
    User
    |> select([u], u)
    |> order_by([u], asc: u.id)
    |> preload(:roles)
    |> Repo.all()
  end

  def list_users_by_role_id(role_id) do
    User
    |> select([u], u)
    |> join(:inner, [u], ru in RoleUser, on: ru.user_id == u.id)
    |> join(:inner, [u, ru], r in Role, on: ru.role_id == r.id and r.id == ^role_id)
    |> order_by([u], asc: u.id)
    |> Repo.all()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
    # IMPORTANT:
    |> case do
      {:ok, user} -> {:ok, Repo.preload(user, :roles)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.registration_changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, user} ->
        user = Repo.preload(user, :roles)
        {:ok, user}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_user_nickname(%User{} = user, attrs) do
    user
    |> User.nickname_changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, user} ->
        user = Repo.preload(user, :roles)
        {:ok, user}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def increase_user_count(%Role{} = role) do
    role
    |> Repo.preload(:users)
    |> Role.changeset(%{user_count: role.user_count + 1})
    |> Repo.update()
  end

  def decrease_user_count(%Role{} = role) do
    new_user_count = max(role.user_count - 1, 0)

    role
    |> Repo.preload(:users)
    |> Role.changeset(%{user_count: new_user_count})
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end

  # ----------------------------------------------------------------------------
  # Role
  # ----------------------------------------------------------------------------

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    Role
    |> select([r], r)
    |> order_by([r], asc: r.id)
    |> preload(:users)
    |> Repo.all()
  end

  def list_roles_by_user_id(user_id) do
    Role
    |> select([r], r)
    |> join(:inner, [r], ru in RoleUser, on: ru.role_id == r.id)
    |> join(:inner, [r, ru], u in User, on: ru.user_id == u.id and u.id == ^user_id)
    |> order_by([r], asc: r.id)
    |> preload([:users])
    |> Repo.all()
  end

  def list_remain_roles_by_user_id(user_id) do
    from(r in Role,
      as: :role,
      where:
        not exists(
          from(ru in RoleUser,
            where: ru.user_id == ^user_id and ru.role_id == parent_as(:role).id
          )
        ),
      preload: [:users]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id) do
    Role
    |> select([r], r)
    |> where([r], r.id == ^id)
    |> preload(:users)
    |> Repo.one!()
  end

  def get_default_role(role_name) do
    Role
    |> select([r], r)
    |> where([r], r.name == ^role_name)
    |> preload(:users)
    |> Repo.one!()
  end

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
    # IMPORTANT:
    |> case do
      {:ok, role} -> {:ok, Repo.preload(role, :users)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Repo.preload(:users)
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    role
    |> Repo.preload(:users)
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    role
    |> Repo.preload(:users)
    |> Role.changeset(attrs)
  end

  # ----------------------------------------------------------------------------
  # RoleUser
  # ----------------------------------------------------------------------------

  def list_role_user do
    RoleUser
    |> select([ru], ru)
    |> order_by([ru], asc: ru.id)
    |> Repo.all()
  end

  def list_role_user_by_user_id(user_id) do
    RoleUser
    |> select([ru], ru)
    |> where([ru], ru.user_id == ^user_id)
    |> order_by([ru], asc: ru.id)
    |> Repo.all()
  end

  def list_role_user_not_user_id(user_id) do
    Role
    |> select([r], r)
    |> join(:left, [r], ru in RoleUser, on: r.id == ru.role_id and ru.user_id == ^user_id)
    |> where([r, ru], is_nil(ru.role_id))
    |> order_by([r], asc: r.id)
    |> Repo.all()
  end

  def get_role_user!(role_id, user_id) do
    RoleUser
    |> select([ru], ru)
    |> where([ru], ru.role_id == ^role_id and ru.user_id == ^user_id)
    |> Repo.one!()
  end

  def get_role_user(role_id, user_id) do
    RoleUser
    |> select([ru], ru)
    |> where([ru], ru.role_id == ^role_id and ru.user_id == ^user_id)
    |> Repo.one()
  end

  def create_role_user(attrs \\ %{}) do
    %RoleUser{}
    |> RoleUser.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, role_user} -> {:ok, role_user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def update_role_user(%RoleUser{} = role_user, attrs) do
    role_user
    |> RoleUser.changeset(attrs)
    |> Repo.update()
  end

  def delete_role_user(%RoleUser{} = role_user) do
    role_user
    |> Repo.delete()
  end

  def change_role_user(%RoleUser{} = role_user, attrs \\ %{}) do
    RoleUser.changeset(role_user, attrs)
  end
end
