defmodule Stockmonit.View.ColumnTest do
  use ExUnit.Case
  alias Stockmonit.View.Column
  doctest Stockmonit.View.Column

  describe "price_column()" do
    test "converts to string, rounded to 2 decimal places" do
      assert Column.price_column(12.3456) == [content: "12.34", color: :default]
    end

    test "returns '-' when value is 0" do
      assert Column.price_column(0) == [content: "-", color: :default]
    end
  end

  describe "current_price_column()" do
    test "sets color to red when current price is lower than previous close" do
      expected = [content: "12.34", color: :red]
      assert Column.current_price_column(12.3456, 13.0) == expected
    end

    test "sets color to green when current price is higher than previous close" do
      expected = [content: "15.34", color: :green]
      assert Column.current_price_column(15.3456, 13.0) == expected
    end

    test "sets color to default when current price is the same as previous close" do
      expected = [content: "13.0", color: :default]
      assert Column.current_price_column(13.0, 13.0) == expected
    end
  end
end
