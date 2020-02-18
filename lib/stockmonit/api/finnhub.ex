defmodule Stockmonit.Api.Finnhub do
  def fetch(symbol, api_key, http_client) do
    url(symbol, api_key)
    |> http_client.get()
    |> Stockmonit.Api.decode_response(&map/1)
  end

  defp url(stock_symbol, token) do
    "https://finnhub.io/api/v1/quote?symbol=#{stock_symbol}&token=#{token}"
  end

  defp map(res) do
    %{
      "c" => current_price,
      "o" => open_price,
      "h" => high_price,
      "l" => low_price,
      "pc" => close_price
    } = res

    %{
      "current_price" => current_price,
      "close_price" => close_price,
      "open_price" => open_price,
      "low_price" => low_price,
      "high_price" => high_price
    }
  end
end
