defmodule Stockmonit.Api.Finnhub do
  def fetch(%{"name" => name, "symbol" => symbol}, api_key) do
    url(symbol, api_key)
    |> HTTPoison.get()
    |> handle_response
  end

  defp url(stock_symbol, token) do
    u = "https://finnhub.io/api/v1/quote?symbol=#{stock_symbol}&token=#{token}"
    IO.puts(u)
    u
  end

  def handle_response({:ok, %{status_code: 200, body: body}}), do: Poison.decode(body)

  def handle_response({_, %{status_code: sc, body: body}}) do
    {:error, "API error: status: #{sc} , '#{body}'"}
  end
end
