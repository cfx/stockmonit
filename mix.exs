defmodule Stockmonit.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :stockmonit,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      docs: [
        source_ref: @version,
        source_url: "https://github.com/cfx/stockmonit",
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Stockmonit, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:poison, "~> 4.0"},
      {:ratatouille, "~> 0.5"},
      {:mox, "~> 0.5", only: :test},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.16", only: :dev}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end

  defp package do
    [
      maintainers: ["Józef Chraplewski"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/cfx/stockmonit"}
    ]
  end
end
