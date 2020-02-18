defmodule Stockmonit.HttpClient do
  @moduledoc false

  defmodule Stockmonit.HttpClient.Response do
    @type t ::
            {:ok, %{status_code: integer(), body: String.t()}}
            | {:error, String.t()}
  end

  @callback get(String.t(), %{}) :: Stockmonit.HttpClient.Response.t()
end
