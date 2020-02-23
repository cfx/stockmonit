defmodule StockmonitTest do
  use ExUnit.Case
  alias Stockmonit.{HttpClientMock, Quote, Results}

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  setup do
    path = TestHelper.fixture("valid_stockmonit.json")

    start_supervised(Stockmonit.Results)
    start_supervised(Stockmonit.StocksSupervisor)
    start_supervised({Stockmonit.Config.Server, path})
    :ok
  end

  def check_results(pid, expected) do
    receive do
      :check ->
        case Results.get() do
          ^expected ->
            send(pid, :ok)

          _empty_map ->
            send(self(), :check)
        end
    end

    check_results(pid, expected)
  end

  def assert_results(expected) do
    spawn(__MODULE__, :check_results, [self(), expected])
    |> send(:check)

    assert_receive(:ok, 200)
  end

  describe "When there are no errors" do
    test "store quote from API call in Results" do
      expect(HttpClientMock, :get, fn _url, _opts ->
        body = """
        {
          "c": 12,
          "o": 10,
          "h": 14,
          "l": 11,
          "pc": 9
        }
        """

        {:ok, body}
      end)

      # Quote results derived from API
      expected_state = %{
        "Nokia" =>
          {:ok,
           %Quote{
             current_price: 12,
             close_price: 9,
             open_price: 10,
             low_price: 11,
             high_price: 14
           }},
        "Foo" => {:error, "Provider not found"}
      }

      assert_results(expected_state)
    end
  end

  describe "When there is API error" do
    test "store error message instead of Quote" do
      expect(HttpClientMock, :get, fn _url, _opts ->
        {:error, "BOOM"}
      end)

      expected_state = %{
        "Nokia" => {:error, "BOOM"},
        "Foo" => {:error, "Provider not found"}
      }

      assert_results(expected_state)
    end
  end

  describe "When API JSON response cannot be parsed" do
    test "store error message instead of Quote" do
      expect(HttpClientMock, :get, fn _url, _opts ->
        {:ok, "\invalid json"}
      end)

      expected_state = %{
        "Nokia" => {:error, "Can't decode response body"},
        "Foo" => {:error, "Provider not found"}
      }

      assert_results(expected_state)
    end
  end
end
