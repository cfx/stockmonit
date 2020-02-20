defmodule Stockmonit.Config.Reader do
  @moduledoc false
  @type t :: {:ok, Stockmonit.Config.t()} | {:error, String.t()}
  @callback read(String.t()) :: t
end
