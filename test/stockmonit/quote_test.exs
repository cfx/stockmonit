defmodule Stockmonit.QuoteTest do
  use ExUnit.Case
  doctest Stockmonit.Quote
  alias Stockmonit.{Quote}

  setup do
    [q: %Quote{}]
  end

  test "returns unchanged %Quote when initial price is nil", %{q: q} do
    assert Quote.add_change(nil, 10, q) == q
  end

  test "returns unchanged %Quote when initial price is 0", %{q: q} do
    assert Quote.add_change(0, 10, q) == q
  end

  test "returns unchanged %Quote when initial price is less than 0", %{q: q} do
    assert Quote.add_change(-2, 10, q) == q
  end

  test "add %Quote.change attribute", %{q: q} do
    assert Quote.add_change(2, 10, q) == %Quote{change: 500}
  end
end
