defmodule Stockmonit.ResultsTest do
  use ExUnit.Case
  doctest Stockmonit.Results
  alias Stockmonit.{Quote, Results}

  setup do
    start_supervised(Stockmonit.Results)
    :ok
  end

  test "stores Quote in map" do
    q = %Quote{current_price: 10}
    Results.put("name", {:ok, q})

    assert Results.get() == %{"name" => {:ok, q}}
  end

  test "stores error message in map" do
    err = {:error, "boom"}
    Results.put("name", err)

    assert Results.get() == %{"name" => err}
  end
end
