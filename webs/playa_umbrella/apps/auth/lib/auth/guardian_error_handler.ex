defmodule Auth.GuardianErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, _opts) do
    body = %{error: type, reason: reason}

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(body))
  end
end
