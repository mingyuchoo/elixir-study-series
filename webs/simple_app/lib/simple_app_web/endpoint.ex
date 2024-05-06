defmodule SimpleAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :simple_app

  plug SimpleAppWeb.Router
end
