use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shortener, ShortenerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :shortener, Shortener.Repo,
  username: "postgres",
  password: "postgres",
  database: "shortener_test",
  hostname: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :shortener, Shortener.Redis, host: System.get_env("REDIS_URL")
