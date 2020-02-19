defmodule Stockmonit.Config.Stock do
  defstruct [:name, :symbol, :api]

  @type t :: %__MODULE__{
          name: String.t(),
          symbol: String.t(),
          api: String.t()
        }
end
