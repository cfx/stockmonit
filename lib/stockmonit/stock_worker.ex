defmodule Stockmonit.StockWorker do
  use GenServer

  def start_link(stock, api_config) do
    GenServer.start_link(__MODULE__, {stock, api_config})
  end

  def init(config) do
    fetch_stock()
    {:ok, config}
  end

  def handle_info(:fetch, {stock, api_config}) do
    IO.inspect(stock)
    IO.inspect(api_config)
    #    fetch_stock()
    {:noreply, {stock, api_config}}
  end

  defp fetch_stock() do
    Process.send_after(self(), :fetch, 0)
  end
end
