defmodule Productivity.Repo do
  use Ecto.Repo,
    otp_app: :productivity,
    adapter: Ecto.Adapters.Postgres
end
