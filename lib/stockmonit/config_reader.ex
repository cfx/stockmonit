defmodule Stockmonit.ConfigReader do
  @moduledoc false
  @type t :: {:ok, Stockmonit.Config.t()} | {:error, String.t()}
  @callback read(String.t()) :: t
end
