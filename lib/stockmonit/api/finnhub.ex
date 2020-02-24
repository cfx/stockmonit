defmodule Stockmonit.Api.Finnhub do
  alias Stockmonit.{Api, Quote}
  @behaviour Api

  @impl Api
  def url(stock_symbol, token) do
    "https://finnhub.io/api/v1/quote?symbol=#{stock_symbol}&token=#{token}"
  end

  @impl Api
  def handler({:ok, body}) do
    Api.decode_json_response(body, &map/1)
  end

  def handler(err), do: err

  defp map(res) do
    %{
      "c" => current_price,
      "o" => open_price,
      "h" => high_price,
      "l" => low_price,
      "pc" => close_price
    } = res

    %Quote{
      current_price: current_price,
      close_price: close_price,
      open_price: open_price,
      low_price: low_price,
      high_price: high_price
    }
  end
end
