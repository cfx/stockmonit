defmodule Stockmonit.Config.ServerTest do
  use ExUnit.Case
  doctest Stockmonit.Config.Server
  alias Stockmonit.Config.{Server, Stock}

  setup_all do
    [stocks: [%Stock{symbol: "FOO"}, %Stock{symbol: "BAR"}]]
  end

  test "stops process when config file returns an error" do
    Process.flag(:trap_exit, true)
    expected = {:error, "Can't load config file"}
    assert ^expected = Server.start_link("/invalid/path")
  end

  describe ".find_stock()" do
    test "returns %Stock when found", %{stocks: stocks} do
      assert Server.find_stock(stocks, "FOO") == %Stock{symbol: "FOO"}
    end

    test "returns nil when not found", %{stocks: stocks} do
      assert Server.find_stock(stocks, "FOO") == %Stock{symbol: "FOO"}
    end
  end
end
