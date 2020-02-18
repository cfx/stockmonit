defmodule Stockmonit.ConfigReader do
  @moduledoc false
  @callback read(String.t()) :: {:ok, Stockmonit.Config.t()} | {:error, String.t()}
end
