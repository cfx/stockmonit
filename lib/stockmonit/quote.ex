defmodule Stockmonit.Quote do
  defstruct [
    :current_price,
    :open_price,
    :close_price,
    :low_price,
    :high_price
  ]

  @type t :: %__MODULE__{
          current_price: float(),
          open_price: float(),
          close_price: float(),
          low_price: float(),
          high_price: float()
        }
end
