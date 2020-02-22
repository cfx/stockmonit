defmodule Stockmonit.Config do
  alias Stockmonit.Config.{Stock, Provider}
  defstruct stocks: [], providers: []

  @type t :: %__MODULE__{
          stocks: [Stock.t()],
          providers: [Provider.t()]
        }

  @type entity :: {Stock.t(), Provider.t()}
  @doc """
  Finds provider for given %Stock struct. Returns pair %Stock %Provider
  if both found.
  """
  @spec find_entity(String.t(), [Stock.t()], [Provider.t()]) ::
          {:ok, entity()} | {:error, String.t()}
  def find_entity(stock_symbol, stocks, providers) do
    case Stock.find(stocks, stock_symbol) do
      nil ->
        {:error, "Stock not found"}

      stock ->
        find_provider_for(stock, providers)
    end
  end

  @spec find_provider_for(Stock.t(), [Provider.t()]) ::
          {:ok, entity()} | {:error, String.t()}
  defp find_provider_for(stock = %Stock{api: api}, providers) do
    case Provider.find(providers, api) do
      nil ->
        {:error, "Provider #{api} not found"}

      provider ->
        {:ok, {stock, provider}}
    end
  end
end
