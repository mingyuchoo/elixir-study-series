# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# having access to Azure OpenAI API.
import Config

# Core app configuration
config :core,
  ecto_repos: [Core.Repo]

config :core, Core.Repo,
  database: Path.expand("../apps/core/priv/agentic_ai.db", __DIR__),
  pool_size: 5,
  show_sensitive_data_on_connection_error: true

# Azure OpenAI Configuration
config :core,
  azure_openai_endpoint: System.get_env("AZURE_OPENAI_ENDPOINT"),
  azure_openai_api_key: System.get_env("AZURE_OPENAI_API_KEY"),
  azure_openai_api_version: System.get_env("AZURE_OPENAI_API_VERSION", "2024-12-01-preview"),
  workspace_dir: Path.expand("../workspace", __DIR__)

# Web app configuration
config :web,
  generators: [context_app: :core]

config :web, WebWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: WebWeb.ErrorHTML, json: WebWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Web.PubSub,
  live_view: [signing_salt: "agentic_ai_secret"]

# Logger configuration
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# JSON library
config :phoenix, :json_library, Jason

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.0",
  web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.17",
  web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/css/app.css
    ),
    cd: Path.expand("../apps/web/assets", __DIR__)
  ]

# Import environment specific config
import_config "#{config_env()}.exs"
