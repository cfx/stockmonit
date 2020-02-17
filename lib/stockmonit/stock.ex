defmodule Stockmonit.Stock do
  defstruct [:name, :symbol, :api]

  @type t :: %Stockmonit.Stock{
          name: String.t(),
          symbol: String.t(),
          api: String.t()
        }
end
