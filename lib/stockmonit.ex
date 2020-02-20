defmodule Stockmonit do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_all, name: Stockmonit.Supervisor]

    children = [
      Stockmonit.Results,
      Stockmonit.StocksSupervisor,
      {Stockmonit.Config.Server, config_path()},
      {Ratatouille.Runtime.Supervisor,
       runtime: [
         app: Stockmonit.View,
         shutdown: {:application, :stockmonit}
       ]}
    ]

    Supervisor.start_link(children, opts)
  end

  @spec stop(term) :: no_return
  def stop(_state) do
    System.halt()
  end

  @spec config_path() :: String.t()
  defp config_path() do
    System.user_home() |> Path.join("/.stockmonit.json")
  end
end
