use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :remote_day, RemoteDayWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :remote_day, RemoteDay.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_ENV_POSTGRES_USER") || "postgres",
  password: System.get_env("DB_ENV_POSTGRES_PASSWORD") || "postgres",
  hostname: System.get_env("DB_ENV_POSTGRES_HOST") || "localhost",
  database: "remote_day_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :remote_day, RemoteDay.Mailer, adapter: Bamboo.TestAdapter
