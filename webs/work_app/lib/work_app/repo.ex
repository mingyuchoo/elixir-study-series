defmodule WorkApp.Repo do
  use Ecto.Repo,
    otp_app: :work_app,
    adapter: Ecto.Adapters.Postgres
end
