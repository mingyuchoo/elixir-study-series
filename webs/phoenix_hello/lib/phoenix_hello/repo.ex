defmodule PhoenixHello.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_hello,
    adapter: Ecto.Adapters.Postgres
end
