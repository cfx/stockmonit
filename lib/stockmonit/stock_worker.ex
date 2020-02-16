defmodule Stockmonit.StockWorker do
  use GenServer
  alias Stockmonit.Api.{Finnhub}

  def start_link(stock, api_config) do
    GenServer.start_link(__MODULE__, {stock, api_config})
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def init(config) do
    fetch_stock(Enum.random(0..9) * 1000)
    {:ok, config}
  end

  def handle_info(:fetch, {stock, api_config}) do
    %{"name" => key, "symbol" => symbol} = stock
    %{"api_key" => api_key, "interval" => interval} = api_config

    case Finnhub.fetch(symbol, api_key) do
      {:ok, data} ->
        Stockmonit.Results.put(key, data)

      {:error, err} ->
        Stockmonit.Results.put(key, %{"error" => err})
    end

    fetch_stock(interval * 1000)
    {:noreply, {stock, api_config}}
  end

  def handle_call(:get, _from, config) do
    {:replay, config, config}
  end

  defp fetch_stock(t) do
    Process.send_after(self(), :fetch, t)
  end
end
