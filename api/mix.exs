defmodule RemoteDay.Mixfile do
  use Mix.Project

  def project do
    [
      app: :remote_day,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RemoteDay.Application, []},
      extra_applications: [
        :absinthe_plug,
        :logger,
        :timex,
        :timex_ecto
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:absinthe_ecto, "~> 0.1.0"},
      {:absinthe_plug, "~> 1.4.0"},
      {:absinthe, "~> 1.4.0"},
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.2"},
      {:excoveralls, "~> 0.10", only: :test},
      {:faker, "~> 0.11"},
      {:gettext, "~> 0.11"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix, "~> 1.3.4"},
      {:plug_cowboy, "~> 1.0"},
      {:poison, "~> 3.1.0"},
      {:postgrex, ">= 0.0.0"},
      {:timex, "~> 3.1"},
      {:timex_ecto, "~> 3.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
