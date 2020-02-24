defmodule Stockmonit.Api do
  alias Stockmonit.{HttpClient, Quote}

  @type stock_symbol :: String.t()
  @type api_key :: String.t()
  @type response :: {:ok, Quote.t()} | {:error, String.t()}

  @callback url(stock_symbol, api_key) :: HttpClient.url()
  @callback handler(HttpClient.response()) :: response

  @doc """
  Fetches quote via provider defined in Stockmonit.Api.<Provider>
  <Provider> has to implement Stockmonit.Api behaviour.
  """
  @spec fetch(stock_symbol, api_key, Stockmonit.Api, HttpClient) ::
          response
  def fetch(symbol, api_key, provider, http_client) do
    provider.url(symbol, api_key)
    |> http_client.get(%{})
    |> provider.handler()
  end

  @spec decode_json_response(HttpClient.body(), fun()) :: response
  def decode_json_response(body, map_fn) do
    case Poison.decode(body) do
      {:ok, data} ->
        {:ok, map_fn.(data)}

      {:error, _} ->
        {:error, "Can't decode response body"}
    end
  end
end
