defmodule Stockmonit.Config do
  alias Stockmonit.Config.{Stock, Provider}
  defstruct stocks: [], providers: []

  @type t :: %Stockmonit.Config{
          stocks: [Stock.t()],
          providers: [Provider.t()]
        }
end
