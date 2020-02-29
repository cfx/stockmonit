defmodule Stockmonit.QuoteTest do
  use ExUnit.Case
  doctest Stockmonit.Quote
  alias Stockmonit.{Quote}

  test "returns nil when initial price is nil" do
    assert Quote.calculate_change(nil, 10) == nil
  end

  test "returns nil when initial price is 0" do
    assert Quote.calculate_change(0, 10) == nil
  end

  test "returns nil when initial price is less than 0" do
    assert Quote.calculate_change(-2, 10) == nil
  end

  test "returns new value" do
    assert Quote.calculate_change(2, 10) == 500
  end
end
