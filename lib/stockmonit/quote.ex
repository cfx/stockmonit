defmodule Stockmonit.Quote do
  defstruct [
    :current_price,
    :open_price,
    :close_price,
    :low_price,
    :high_price,
    :change
  ]

  @type price :: float() | integer()

  @type t :: %__MODULE__{
          current_price: price(),
          open_price: price(),
          close_price: price(),
          low_price: price(),
          high_price: price(),
          change: price()
        }

  @doc """
  Adds %Quote.change which reflects change between old and new price
  """
  @spec add_change(price(), price(), __MODULE__.t()) :: __MODULE__.t()
  def add_change(nil, _new_price, q), do: q
  def add_change(old_price, _new_price, q) when old_price <= 0, do: q

  def add_change(old_price, new_price, q) do
    Map.put(q, :change, new_price / old_price * 100)
  end
end
