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
  Calculates new value comparing old and new price.
  """
  @spec calculate_change(price(), price()) :: price()
  def calculate_change(old_price, _new_price) when old_price <= 0 or is_nil(old_price), do: nil

  def calculate_change(old_price, new_price) do
    new_price / old_price * 100
  end
end
