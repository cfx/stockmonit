defmodule Stockmonit.MixProject do
  use Mix.Project

  def project do
    [
      app: :stockmonit,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package()
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
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
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
