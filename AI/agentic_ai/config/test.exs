import Config

# Test configuration
config :core, Core.Repo,
  database: Path.expand("../apps/core/priv/test.db", __DIR__),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test
config :web, WebWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base:
    "test_secret_key_base_must_be_at_least_64_bytes_long_for_security_purposes_here",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
