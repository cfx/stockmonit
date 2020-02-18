defmodule Stockmonit.StockQuote do
  defstruct [
    :current_price,
    :open_price,
    :close_price,
    :low_price,
    :high_price
  ]

  @type t :: %Stockmonit.StockQuote{
          current_price: Float.t(),
          open_price: Float.t(),
          close_price: Float.t(),
          low_price: Float.t(),
          high_price: Float.t()
        }
end
