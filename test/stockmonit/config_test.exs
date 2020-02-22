defmodule Stockmonit.ConfigTest do
  use ExUnit.Case
  doctest Stockmonit.Config
  alias Stockmonit.Config.{Stock, Provider}
  alias Stockmonit.Config

  setup_all do
    [providers: [%Provider{name: "P1"}, %Provider{name: "P2"}]]
  end

  describe ".find()" do
    test "returns both %Stock and %Provider for given %Stock", %{providers: providers} do
      stock = %Stock{api: "P1"}
      assert Config.find_stock_config(stock, providers) == {:ok, {stock, %Provider{name: "P1"}}}
    end

    test "returns error when %Stock is nil", %{providers: providers} do
      assert Config.find_stock_config(nil, providers) == {:error, "Stock not found"}
    end

    test "returns error when %Provider cannot be found", %{providers: providers} do
      stock = %Stock{api: "P3"}
      assert Config.find_stock_config(stock, providers) == {:error, "Provider P3 not found"}
    end
  end
end
