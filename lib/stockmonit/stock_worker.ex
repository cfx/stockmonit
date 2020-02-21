defmodule Stockmonit.StockWorker do
  use GenServer
  alias Stockmonit.Config.{Provider}
  alias Stockmonit.{Api, Config, Results}

  @default_interval 60

  def start_link(stock) do
    GenServer.start_link(__MODULE__, stock)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def init(stock) do
    fetch(Enum.random(0..9) * base_interval())
    {:ok, stock}
  end

  def handle_info(:fetch, stock) do
    provider =
      Config.Server.get_providers()
      |> Provider.find(stock.api)

    update_results(stock, provider)

    case provider do
      nil ->
        fetch(@default_interval * base_interval())

      _ ->
        fetch(provider.interval * base_interval())
    end

    {:noreply, stock}
  end

  def handle_call(:get, _from, stock) do
    {:reply, stock, stock}
  end

  defp update_results(stock, nil) do
    Results.put(stock.name, {:error, "Provider not found"})
  end

  defp update_results(stock, provider) do
    api = Provider.to_atom(provider.name)

    case Api.fetch(stock.symbol, provider.api_key, api, http_client()) do
      {:ok, stock_quote} ->
        Results.put(stock.name, {:ok, stock_quote})

      {:error, err} ->
        Results.put(stock.name, {:error, err})
    end
  end

  defp fetch(t) do
    Process.send_after(self(), :fetch, t)
  end

  defp http_client() do
    Application.get_env(:stockmonit, :http_client)
  end

  @spec base_interval() :: integer()
  defp base_interval() do
    Application.get_env(:stockmonit, :api_fetch_interval)
  end
end
