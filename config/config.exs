# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cookpod,
  ecto_repos: [Cookpod.Repo]

# Configures the endpoint
config :cookpod, CookpodWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WZh2RKoDe7GITiaSadC4gRztSp6fY5Fn+Ygc0K0he0AeFE/97OVOoitpCnZrEL4W",
  render_errors: [view: CookpodWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cookpod.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "QkGT5tyV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimleex: PhoenixSlime.LiveViewEngine

config :cookpod, CookpodWeb.Gettext, default_locale: "ru", locales: ~w(en ru)  


# Congfiguration for Email Checker
config :email_checker,
  default_dns: :system,
  also_dns: [],
  validations: [EmailChecker.Check.Format, EmailChecker.Check.MX],
  smtp_retries: 2,
  timeout_milliseconds: :infinity
  
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
