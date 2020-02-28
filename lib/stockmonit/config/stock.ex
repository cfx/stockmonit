defmodule Stockmonit.Config.Stock do
  defstruct [:name, :symbol, :api, :purchase_price]

  @type symbol :: String.t()
  @type api_key :: String.t()
  @type price :: float() | integer()

  @type t :: %__MODULE__{
          name: String.t(),
          symbol: symbol,
          api: api_key,
          purchase_price: price()
        }
end
