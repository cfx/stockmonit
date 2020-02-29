defmodule Stockmonit.Api.FinnhubTest do
  use ExUnit.Case
  doctest Stockmonit.Api.Finnhub
  alias Stockmonit.{Api, Quote, HttpClientMock}
  alias Stockmonit.Config.Stock
  alias Api.Finnhub

  import Mox
  setup :set_mox_global

  setup do
    [stock: %Stock{symbol: "NOK"}]
  end

  test "maps finnhub api json response to %Quote", %{stock: stock} do
    expect(HttpClientMock, :get, fn _url, _opts ->
      body = """
      {
        "c": 12,
        "o": 10,
        "h": 14,
        "l": 11,
        "pc": 9
      }
      """

      {:ok, body}
    end)

    expected = %Quote{
      current_price: 12,
      close_price: 9,
      open_price: 10,
      low_price: 11,
      high_price: 14
    }

    assert Api.fetch(stock, "secret", Finnhub, HttpClientMock) == {:ok, expected}
  end

  test "returns error message on error", %{stock: stock} do
    err = "boom"

    expect(HttpClientMock, :get, fn _url, _opts ->
      {:error, err}
    end)

    assert Api.fetch(stock, "secret", Finnhub, HttpClientMock) == {:error, err}
  end

  test "returns error message on json error", %{stock: stock} do
    err = "Can't decode response body"

    expect(HttpClientMock, :get, fn _url, _opts ->
      {:ok, "]invalid-json"}
    end)

    assert Api.fetch(stock, "secret", Finnhub, HttpClientMock) == {:error, err}
  end
end
