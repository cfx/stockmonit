defmodule Stockmonit.Config.Reader do
  @moduledoc false
  @callback read() :: {:ok, term} | {:error, String.t()}
end
