defmodule Stockmonit.Application do
  @config_filename ".stockmonit.json"

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    runtime_opts = [
      app: Stockmonit.App,
      shutdown: {:application, :stockmonit}
    ]

    children = [
      Stockmonit.StockSupervisor,
      {Stockmonit.Server, @config_filename},
      {Ratatouille.Runtime.Supervisor, runtime: runtime_opts}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: Stockmonit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def stop(_state) do
    System.halt()
  end
end
