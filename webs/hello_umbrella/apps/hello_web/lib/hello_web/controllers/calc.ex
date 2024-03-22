defmodule HelloWeb.CalcController do
  use HelloWeb, :controller

  def index(conn, params) do
    case params do
    %{"op" => op, "x1" => x1, "x2" => x2}  ->
        case op do
          "add"      -> json(conn, %{status: :ok,    message: :add})
          "subtract" -> json(conn, %{status: :ok,    message: :subtract})
          "multiply" -> json(conn, %{status: :ok,    message: :multiply})
          "divide"   -> json(conn, %{status: :ok,    message: :divide})
          _         -> json(conn, %{status: :error, message: "Not proper operator."})
        end
      _ -> json(conn, %{status: :error, message: "Parameters are not proper."})
    end
  end
end
