defmodule Stockmonit.Config.Stock do
  defstruct [:name, :symbol, :api]

  @type t :: %Stockmonit.Config.Stock{
          name: String.t(),
          symbol: String.t(),
          api: String.t()
        }
end
