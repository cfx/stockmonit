defmodule Stockmonit.Config.Stock do
  defstruct [:name, :symbol, :api]

  @type symbol :: String.t()
  @type api_key :: String.t()

  @type t :: %__MODULE__{
          name: String.t(),
          symbol: symbol,
          api: api_key
        }
end
