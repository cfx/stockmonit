defmodule Stockmonit.Config.StockTest do
  use ExUnit.Case
  doctest Stockmonit.Config.Stock
  alias Stockmonit.Config.Stock

  setup_all do
    [stocks: [%Stock{symbol: "FOO"}, %Stock{symbol: "BAR"}]]
  end

  describe ".find()" do
    test "returns %Stock when found", %{stocks: stocks} do
      assert Stock.find(stocks, "FOO") == %Stock{symbol: "FOO"}
    end

    test "returns nil when not found", %{stocks: stocks} do
      assert Stock.find(stocks, "FOO") == %Stock{symbol: "FOO"}
    end
  end
end
