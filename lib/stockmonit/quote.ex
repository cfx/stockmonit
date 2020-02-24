defmodule Stockmonit.Quote do
  defstruct [
    :current_price,
    :open_price,
    :close_price,
    :low_price,
    :high_price
  ]

  @type price :: float() | integer()

  @type t :: %__MODULE__{
          current_price: price(),
          open_price: price(),
          close_price: price(),
          low_price: price(),
          high_price: price()
        }
end
