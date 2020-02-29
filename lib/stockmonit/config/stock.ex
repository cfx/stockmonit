defmodule Stockmonit.Config.Stock do
  defstruct [:name, :symbol, :api, :purchase_price]

  @type symbol :: String.t()
  @type api :: String.t()
  @type price :: float() | integer()

  @type t :: %__MODULE__{
          name: String.t(),
          symbol: symbol,
          api: api,
          purchase_price: price()
        }
end
