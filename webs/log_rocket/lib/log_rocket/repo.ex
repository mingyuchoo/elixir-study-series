defmodule LogRocket.Repo do
  use Ecto.Repo,
    otp_app: :log_rocket,
    adapter: Ecto.Adapters.Postgres
end
