defmodule PlayaWeb.AuthController do
  use PlayaWeb, :controller

  alias Playa.Accounts
  alias Auth.Guardian

  def get_token(conn, %{"email" => email, "password" => password}) do
    user = Accounts.get_user_by_email_and_password(email, password)

    case user do
      nil ->
        conn
        |> put_status(401)
        |> json(%{error: "Invalid credentials"})

      _ ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign_with_ttl(user)

        conn
        |> put_status(200)
        |> json(%{token: jwt})
    end
  end

  def me(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> put_status(401)
        |> json(%{error: "User not authenticated"})

      user ->
        conn
        |> put_status(200)
        |> json(%{email: user.email, id: user.id, is_admin: Accounts.is_admin?(user)})
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.current_token(conn)
    |> Guardian.revoke()

    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end
end
