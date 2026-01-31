import Config

# Production configuration
config :web, WebWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration
config :web, WebWeb.Endpoint, server: true
