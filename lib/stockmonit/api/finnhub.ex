defmodule Stockmonit.Api.Finnhub do
  @moduledoc """
  API GET Quote client for Finnhub API.
  See https://finnhub.io/docs/api#quote
  """

  alias Stockmonit.{Api, Quote}
  alias Stockmonit.Config.{Stock}
  @behaviour Api

  @impl Api
  def url(stock_symbol, token) do
    "https://finnhub.io/api/v1/quote?symbol=#{stock_symbol}&token=#{token}"
  end

  @impl Api
  def handler({:ok, body}, %Stock{purchase_price: purchase_price}) do
    Api.decode_json_response(body, fn res ->
      case res do
        %{"error" => error} ->
          {:error, error}

        %{
          "c" => current_price,
          "o" => open_price,
          "h" => high_price,
          "l" => low_price,
          "pc" => close_price
        } ->
          q = %Quote{
            current_price: current_price,
            close_price: close_price,
            open_price: open_price,
            low_price: low_price,
            high_price: high_price,
            change: Quote.calculate_change(purchase_price, close_price)
          }

          {:ok, q}
      end
    end)
  end

  def handler(err, _stock), do: err
end
