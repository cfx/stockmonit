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

  def handle_call(:get, _, config), do: {:reply, config, config}

  def handle_call(:get_providers, _, cfg = %Config{providers: providers}) do
    {:reply, providers, cfg}
  end

  def handle_call({:find_stock, stock_symbol}, _, cfg) do
    {:reply, find_stock(cfg.stocks, stock_symbol), cfg}
  end

  def handle_info(:init_stocks, cfg = %Config{stocks: stocks}) do
    stocks |> Enum.each(&Stockmonit.StocksSupervisor.add_stock(&1))
    {:noreply, cfg}
  end

  ### Impl ###

  @doc """
  Finds Stock by symbol in %Config.stocks
  """

  @spec find_stock([Stock.t()], String.t()) :: Stock.t() | nil
  def find_stock(stocks, stock_symbol) do
    stocks
    |> Enum.find(fn s ->
      s.symbol == stock_symbol
    end)
  end

  @spec config_reader() :: Config.Reader
  defp config_reader() do
    Application.get_env(:stockmonit, :config_reader)
  end
end
