defmodule Stockmonit.Api do
  def decode_response({:ok, body}, map_fn) do
    case Poison.decode(body) do
      {:ok, data} ->
        {:ok, map_fn.(data)}

      {:error, _} ->
        {:error, "Can't decode response body"}
    end
  end

  def decode_response(res = {:error, _}, _map_fn), do: res
end
