defmodule Stockmonit.Api.Finnhub do
  def fetch(symbol, api_key) do
    url(symbol, api_key)
    |> HTTPoison.get()
    |> handle_response
  end

  defp url(stock_symbol, token) do
    "https://finnhub.io/api/v1/quote?symbol=#{stock_symbol}&token=#{token}"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    case Poison.decode(body) do
      {:ok, obj} -> {:ok, map(obj)}
    end
  end

  def handle_response({_, %{status_code: sc, body: body}}) do
    {:error, "API error: status: #{sc} , '#{body}'"}
  end

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
