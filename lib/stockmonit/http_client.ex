defmodule Stockmonit.HttpClient do
  @moduledoc false

  @type url :: String.t()
  @type body :: String.t()
  @type response :: {:ok, body} | {:error, String.t()}

  @callback get(url, %{}) :: response
end
