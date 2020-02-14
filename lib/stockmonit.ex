defmodule Stockmonit do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_all, name: Stockmonit.Supervisor]

    Application.get_env(:stockmonit, :children)
    |> Supervisor.start_link(opts)
  end

  def stop(_state) do
    System.halt()
  end
end
