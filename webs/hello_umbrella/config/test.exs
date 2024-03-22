import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hello_web, HelloWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "mngh2s8uEOuUkByCVKukHKbfcqtfX7Ial9FSze/YYAl7QchjDc7LIAT/qGCxumMX",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
