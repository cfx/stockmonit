defmodule Stockmonit.Api do
  alias Stockmonit.{HttpClient, Quote}
  alias Stockmonit.Config.{Provider, Stock}

  @type response :: {:ok, Quote.t()} | {:error, String.t()}

  @callback url(Stock.symbol(), Provider.api_key()) :: HttpClient.url()
  @callback handler(HttpClient.response(), Stock.t()) :: response

  @doc """
  Fetches quote via provider defined in Stockmonit.Api.<Provider>
  <Provider> has to implement Stockmonit.Api behaviour.
  """
  @spec fetch(Stock.t(), Provider.api_key(), Stockmonit.Api, HttpClient) ::
          response
  def fetch(stock, api_key, provider, http_client) do
    provider.url(stock.symbol, api_key)
    |> http_client.get(%{})
    |> provider.handler(stock)
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
