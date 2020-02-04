defmodule Stockmonit.Api.Finnhub do
  def fetch(%{"name" => name, "symbol" => symbol}, api_key) do
    IO.puts("#{name} stock: #{symbol} key: #{api_key}")
  end
end
