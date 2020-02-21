defmodule Stockmonit.ApiTest do
  use ExUnit.Case
  doctest Stockmonit.Api
  alias Stockmonit.{Api, Quote, HttpClientMock}

  describe ".decode_json_response" do
    test "returns error when json is invalid" do
      assert Api.decode_json_response("\boom", fn -> nil end) ==
               {:error, "Can't decode response body"}
    end

    test "returns results of callback passed" do
      got =
        Api.decode_json_response("{ \"x\": 5}", fn %{"x" => n} ->
          %Quote{current_price: n * 10}
        end)

      assert got == {:ok, %Quote{current_price: 50}}
    end
  end
end
