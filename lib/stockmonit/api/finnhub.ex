defmodule Stockmonit.Api.Finnhub do
  def fetch(symbol, api_key, http_client) do
    url(symbol, api_key)
    |> http_client.get()
    |> decode_response
  end

  defp url(stock_symbol, token) do
    "https://finnhub.io/api/v1/quote?symbol=#{stock_symbol}&token=#{token}"
  end

  defp decode_response({:ok, body}) do
    case Poison.decode(body) do
      {:ok, data} ->
        {:ok, map(data)}

      {:error, _} ->
        {:error, "Can't decode response body"}
    end
  end

  defp decode_response(res = {:error, _}), do: res

  defp map(obj) do
    %{
      "c" => current_price,
      "o" => open_price,
      "h" => high_price,
      "l" => low_price,
      "pc" => close_price
    } = obj

    %{
      "current_price" => current_price,
      "close_price" => close_price,
      "open_price" => open_price,
      "low_price" => low_price,
      "high_price" => high_price
    }
  end
end
