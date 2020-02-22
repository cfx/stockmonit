defmodule Stockmonit.Config.Stock do
  defstruct [:name, :symbol, :api]

  @type t :: %__MODULE__{
          name: String.t(),
          symbol: String.t(),
          api: String.t()
        }

  @doc """
  Finds Stock by symbol in %Config.stocks
  """
  @spec find([__MODULE__.t()], String.t()) :: __MODULE__.t() | nil
  def find(stocks, symbol) do
    stocks |> Enum.find(fn stock -> stock.symbol == symbol end)
  end
end
