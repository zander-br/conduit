# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :conduit,
  ecto_repos: [Conduit.Repo],
  event_stores: [Conduit.EventStore],
  generators: [binary_id: true]

# Configures the endpoint
config :conduit, ConduitWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ConduitWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Conduit.PubSub,
  live_view: [signing_salt: "S4mhXNxa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :conduit, Conduit.App,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Conduit.EventStore
  ],
  pubsub: :local,
  registry: :local

config :vex,
  sources: [
    Conduit.Accounts.Validators,
    Conduit.Support.Validators,
    Vex.Validators
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
