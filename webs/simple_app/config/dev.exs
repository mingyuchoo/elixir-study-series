import Config

config :simple_app, SimpleAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "W7lZ+dfSc4Fcyp8D9EwqyDxY5X2MGBAmreHZsn41T7xzadMhso6ToPAgpzXfHtOh",
  watchers: []

config :simple_app, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
