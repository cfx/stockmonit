defmodule Stockmonit.ConfigTest do
  use ExUnit.Case
  doctest Stockmonit.Config
  alias Stockmonit.Config.{Stock, Provider}
  alias Stockmonit.Config

  setup_all do
    [
      stocks: [%Stock{symbol: "FOO", api: "P1"}, %Stock{symbol: "BAR", api: "P3"}],
      providers: [%Provider{name: "P1"}, %Provider{name: "P2"}]
    ]
  end

  describe ".find_entity(%Stock)" do
    test "returns both %Stock and %Provider for given %Stock", %{
      providers: providers,
      stocks: stocks
    } do
      assert Config.find_entity("FOO", stocks, providers) ==
               {:ok, {%Stock{symbol: "FOO", api: "P1"}, %Provider{name: "P1"}}}
    end

    test "returns error when %Stock is not found", %{providers: providers, stocks: stocks} do
      assert Config.find_entity("XXX", stocks, providers) == {:error, "Stock not found"}
    end

    test "returns error when %Provider cannot be found", %{stocks: stocks, providers: providers} do
      assert Config.find_entity("BAR", stocks, providers) == {:error, "Provider P3 not found"}
    end
  end
end
