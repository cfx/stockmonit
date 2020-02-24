defmodule Stockmonit.StockWorker do
  use GenServer
  alias Stockmonit.Config.{Provider}
  alias Stockmonit.{Api, HttpClient, Results}

  def start_link(stock, provider) do
    GenServer.start_link(__MODULE__, {stock, provider})
  end

  def init(config) do
    # Do not make all requests to API at once.
    fetch(Enum.random(0..4) * base_interval())
    {:ok, config}
  end

  @doc """
  Fetches Quote periodically from given provider and stores it in Results.
  If error occurs error message is also stored.
  """
  def handle_info(:fetch, config = {stock, nil}) do
    Results.put(stock.name, {:error, "Provider not found"})
    {:noreply, config}
  end

  def handle_info(:fetch, config = {stock, provider}) do
    api = Provider.to_atom(stock.api)

    case Api.fetch(stock.symbol, provider.api_key, api, http_client()) do
      {:ok, stock_quote} ->
        Results.put(stock.name, {:ok, stock_quote})

      {:error, err} ->
        Results.put(stock.name, {:error, err})
    end

    fetch(provider.interval * base_interval())

    {:noreply, config}
  end

  defp fetch(t) do
    Process.send_after(self(), :fetch, t)
  end

  @spec http_client() :: HttpClient
  defp http_client() do
    Application.get_env(:stockmonit, :http_client)
  end

  @spec base_interval() :: integer()
  defp base_interval() do
    Application.get_env(:stockmonit, :api_fetch_interval)
  end
end
