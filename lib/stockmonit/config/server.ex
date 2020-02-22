defmodule Stockmonit.Config.Server do
  use GenServer
  alias Stockmonit.Config
  alias Config.Stock

  ### API ###

  def init(path) do
    case config_reader().read(path) do
      {:error, msg} ->
        {:stop, msg}

      data ->
        Process.send_after(self(), :init_stocks, 0)
        data
    end
  end

  def start_link(path) do
    GenServer.start_link(__MODULE__, path, name: __MODULE__)
  end

  def get(), do: GenServer.call(__MODULE__, :get)
  def get_providers(), do: GenServer.call(__MODULE__, :get_providers)

  def find_stock_config(stock_symbol) do
    GenServer.call(__MODULE__, {:find_stock_config, stock_symbol})
  end

  def handle_call(:get, _, config), do: {:reply, config, config}

  def handle_call(:get_providers, _, cfg = %Config{providers: providers}) do
    {:reply, providers, cfg}
  end

  def handle_call(
        {:find_stock_config, stock_symbol},
        _from,
        cfg = %Config{stocks: stocks, providers: providers}
      ) do
    config =
      stocks
      |> Stock.find(stock_symbol)
      |> Config.find_stock_config(providers)

    {:reply, config, cfg}
  end

  def handle_info(:init_stocks, cfg) do
    cfg.stocks
    |> Enum.each(fn stock ->
      Stockmonit.StocksSupervisor.add_stock(stock.symbol)
    end)

    {:noreply, cfg}
  end

  @spec config_reader() :: Config.Reader
  defp config_reader() do
    Application.get_env(:stockmonit, :config_reader)
  end
end
