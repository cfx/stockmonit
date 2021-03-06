defmodule Stockmonit.View.PresenterTest do
  use ExUnit.Case
  alias Stockmonit.View.Presenter
  doctest Stockmonit.View.Presenter

  describe "price_column()" do
    test "converts to string, rounded to 2 decimal places" do
      assert Presenter.price_column(12.3456) == [content: "12.34", color: :default]
    end

    test "works with integers" do
      assert Presenter.price_column(12) == [content: "12", color: :default]
    end
  end

  describe "current_price_column()" do
    test "sets color to red when current price is lower than previous close" do
      expected = [content: "12.34", color: :red]
      assert Presenter.current_price_column(12.3456, 13.0) == expected
    end

    test "sets color to green when current price is higher than previous close" do
      expected = [content: "15.34", color: :green]
      assert Presenter.current_price_column(15.3456, 13.0) == expected
    end

    test "sets color to default when current price is the same as previous close" do
      expected = [content: "13.0", color: :default]
      assert Presenter.current_price_column(13.0, 13.0) == expected
    end
  end

  describe ".change_column()" do
    test "show drop in % in red color" do
      expected = [content: "-25.0%", color: :red]
      assert Presenter.change_column(75.0) == expected
    end

    test "show growth in % in green color" do
      expected = [content: "10.0%", color: :green]
      assert Presenter.change_column(110.0) == expected
    end

    test "show '-' and default color when nil" do
      expected = [content: "-", color: :default]
      assert Presenter.change_column(nil) == expected
    end

    test "show '-' and default color when 0" do
      expected = [content: "-", color: :default]
      assert Presenter.change_column(0) == expected
    end
  end
end
