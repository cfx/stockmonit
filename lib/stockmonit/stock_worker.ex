defmodule Stockmonit.StockWorker do
  use GenServer
  alias Stockmonit.Config.{Provider}
  alias Stockmonit.Results

  #  import :timer, only: [sleep: 1]

  def start_link(stock, api_config) do
    GenServer.start_link(__MODULE__, {stock, api_config})
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def init(config) do
    fetch(Enum.random(0..9) * 1000)
    {:ok, config}
  end

  def handle_info(:fetch, {stock, providers}) do
    case Provider.find(providers, stock.api) do
      nil ->
        {:stop, "provider not found"}

      provider ->
        update_results(stock, provider)
        fetch(provider.interval * 1000)
    end

    {:noreply, {stock, providers}}
  end

  def handle_call(:get, _from, config) do
    {:replay, config, config}
  end

  def update_results(stock, provider) do
    api = Provider.to_atom(provider.name)

    case api.fetch(stock.symbol, provider.api_key, http_client()) do
      {:ok, data} ->
        Results.put(stock.name, data)

      {:error, err} ->
        Results.put(stock.name, %{"error" => err})
    end
  end

  defp fetch(t) do
    Process.send_after(self(), :fetch, t)
  end

  defp http_client() do
    Application.get_env(:stockmonit, :http_client)
  end
end
