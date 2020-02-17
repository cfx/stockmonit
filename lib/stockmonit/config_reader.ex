defmodule Stockmonit.ConfigReader do
  @moduledoc false
  @callback read() :: {:ok, Stockmonit.Config.t()} | {:error, String.t()}
end
