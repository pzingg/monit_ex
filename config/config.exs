# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :mime, :types, %{
  "application/xml" => ["xml"]
}

config :monit_ex,
  ecto_repos: [MonitEx.Repo]

# Configures the endpoint
config :monit_ex, MonitExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0TyV8vKnx1RzPwk8XZ7gZRv7xpvk3MrpAJvipjscHBwJE/swmJRiUO1IHTZWWupl",
  render_errors: [view: MonitExWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MonitEx.PubSub,
  live_view: [signing_salt: "jANmcEd5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
