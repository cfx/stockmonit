defmodule Stockmonit.Config do
  alias Stockmonit.Config.{Stock, Provider}
  defstruct stocks: [], providers: []

  @type t :: %__MODULE__{
          stocks: [Stock.t()],
          providers: [Provider.t()]
        }

  @doc """
  Finds provider for given %Stock struct. Returns pair %Stock %Provider
  if both found.
  """
  @spec find_stock_config(Stock.t() | nil, [Provider.t()]) ::
          {:ok, {Stock.t(), Provider.t()}} | {:error, String.t()}

  def find_stock_config(nil, _providers), do: {:error, "Stock not found"}

  def find_stock_config(stock = %Stock{api: api}, providers) do
    case Provider.find(providers, api) do
      nil ->
        {:error, "Provider #{api} not found"}

      provider ->
        {:ok, {stock, provider}}
    end
  end
end
