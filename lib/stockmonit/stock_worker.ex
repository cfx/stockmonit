defmodule Stockmonit.StockWorker do
  use GenServer
  alias Stockmonit.Config.{Stock, Provider}
  alias Stockmonit.{Api, Config, Results}

  @default_interval 60

  def start_link(stock_symbol) do
    GenServer.start_link(__MODULE__, stock_symbol)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def init(stock_symbol) do
    fetch(Enum.random(0..9) * base_interval())
    {:ok, stock_symbol}
  end

  def handle_info(:fetch, stock_symbol) do
    case Config.Server.find_stock_config(stock_symbol) do
      {:ok, {stock, provider}} ->
        update_results(stock, provider)
        fetch(provider.interval * base_interval())

      {:error, err} ->
        Results.put(stock_symbol, {:error, err})
        fetch(@default_interval * base_interval())
    end

    {:noreply, stock_symbol}
  end

  def handle_call(:get, _from, stock) do
    {:reply, stock, stock}
  end

  @spec update_results(Stock.t(), Provider.t()) :: term
  defp update_results(stock, provider) do
    api = Provider.to_atom(provider.name)

    case Api.fetch(stock.symbol, provider.api_key, api, http_client()) do
      {:ok, stock_quote} ->
        Results.put(stock.name, {:ok, stock_quote})

      {:error, err} ->
        Results.put(stock.name, {:error, err})
    end
  end

  @spec base_interval() :: integer()
  defp base_interval() do
    Application.get_env(:stockmonit, :api_fetch_interval)
  end

  defp fetch(t) do
    Process.send_after(self(), :fetch, t)
  end

  defp http_client() do
    Application.get_env(:stockmonit, :http_client)
  end
end
