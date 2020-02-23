defmodule Stockmonit.Config do
  alias Stockmonit.Config.{Stock, Provider}
  defstruct stocks: [], providers: %{}

  @type t :: %__MODULE__{
          stocks: [Stock.t()],
          providers: %{required(String.t()) => Provider.t()}
        }
end
