# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :remote_day,
  ecto_repos: [RemoteDay.Repo]

# Configures the endpoint
config :remote_day, RemoteDayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("ENDPOINT_SECRET_KEY"),
  render_errors: [view: RemoteDayWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: RemoteDay.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Guardian
config :remote_day, RemoteDay.Account.Guardian,
  issuer: "remote_day",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

if Mix.env() == :dev do
  config :mix_test_watch,
    clear: true
end

config :remote_day, RemoteDay.Scheduler,
  jobs: [
    # Every day at 9:30
    {"30 9 * * *", {RemoteDay.Jobs.RemoteWorkers, :send_daily_emails, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
