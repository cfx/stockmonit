defmodule Stockmonit.StockWorker do
  use GenServer
  alias Stockmonit.Api.Finnhub

  def start_link(stock, api_config) do
    GenServer.start_link(__MODULE__, {stock, api_config})
  end

  def init(config) do
    fetch_stock()
    {:ok, config}
  end

  def handle_info(:fetch, {stock, api_config = %{"api_key" => api_key}}) do
    #    fetch_stock()
    IO.inspect(Finnhub.fetch(stock, api_key))
    {:noreply, {stock, api_config}}
  end

  defp fetch_stock() do
    Process.send_after(self(), :fetch, 1000)
  end
end
