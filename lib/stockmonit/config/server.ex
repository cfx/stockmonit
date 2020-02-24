defmodule Stockmonit.Config.Server do
  @moduledoc """
  Loads .stockmonit.json via Config.t() and starts
  stock workers.
  """

  use GenServer
  alias Stockmonit.Config

  def init(path) do
    case config_reader().read(path) do
      {:error, msg} ->
        {:stop, msg}

      data ->
        Process.send_after(self(), :start_workers, 0)
        data
    end
  end

  def start_link(path) do
    GenServer.start_link(__MODULE__, path, name: __MODULE__)
  end

  def stop() do
    GenServer.stop(__MODULE__, :normal)
  end

  def handle_info(:start_workers, config = %Config{stocks: stocks, providers: providers}) do
    stocks
    |> Enum.each(fn stock ->
      Stockmonit.StocksSupervisor.add_stock(stock, providers[stock.api])
    end)

    {:noreply, config}
  end

  @spec config_reader() :: Config.Reader
  defp config_reader() do
    Application.get_env(:stockmonit, :config_reader)
  end
end
