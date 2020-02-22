defmodule Stockmonit.Config.Server do
  use GenServer
  alias Stockmonit.Config

  def start_link(path) do
    GenServer.start_link(__MODULE__, path, name: __MODULE__)
  end

  def init(path) do
    case config_reader().read(path) do
      {:error, msg} ->
        {:stop, msg}

      data ->
        Process.send_after(self(), :init_stocks, 0)
        data
    end
  end

  def handle_info(:init_stocks, cfg) do
    cfg.stocks
    |> Enum.each(fn stock ->
      Stockmonit.StocksSupervisor.add_stock(stock.symbol)
    end)

    {:noreply, cfg}
  end

  def find_stock_config(stock_symbol) do
    GenServer.call(__MODULE__, {:find_stock_config, stock_symbol})
  end

  def handle_call({:find_stock_config, stock_symbol}, _, cfg) do
    %Config{stocks: stocks, providers: providers} = cfg
    {:reply, Config.find_entity(stock_symbol, stocks, providers), cfg}
  end

  @spec config_reader() :: Config.Reader
  defp config_reader() do
    Application.get_env(:stockmonit, :config_reader)
  end
end
