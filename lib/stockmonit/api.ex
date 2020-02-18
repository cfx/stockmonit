defmodule Stockmonit.Api do
  @moduledoc false
  @callback fetch(String.t(), String.t(), Stockmonit.HttpClient) ::
              {:ok, Stockmonit.Quote.t()} | {:error, String.t()}

  def decode_json_response({:ok, body}, map_fn) do
    case Poison.decode(body) do
      {:ok, data} ->
        {:ok, map_fn.(data)}

      {:error, _} ->
        {:error, "Can't decode response body"}
    end
  end

  def decode_json_response(res = {:error, _}, _map_fn), do: res
end
