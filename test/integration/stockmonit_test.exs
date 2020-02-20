defmodule StockmonitTest do
  use ExUnit.Case
  alias Stockmonit.{HttpClientMock, Quote, Results, Config}

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  # def start_app do
  #  path = TestHelper.fixtures_dir() |> Path.join("valid_stockmonit.json")
  #  opts = [strategy: :one_for_all, name: Stockmonit.Supervisor]

  #  children = [
  #    Stockmonit.Results,
  #    Stockmonit.StocksSupervisor,
  #    {Stockmonit.Config.Server, path}
  #  ]

  #  Supervisor.start_link(children, opts)
  # end

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

    assert_receive(:ok, 500)
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

      expected_state = %{
        "Nokia" =>
          {:ok,
           %Quote{
             current_price: 12,
             close_price: 9,
             open_price: 10,
             low_price: 11,
             high_price: 14
           }}
      }

      expected_config = %Config{
        stocks: [
          %Config.Stock{
            api: "Finnhub",
            name: "Nokia",
            symbol: "NOK"
          }
        ],
        providers: [
          %Config.Provider{
            name: "Finnhub",
            api_key: "secret",
            interval: 60
          }
        ]
      }

      assert_results(expected_state)
      assert Config.Server.get() == expected_config
    end
  end

  describe "When there are errors from Provider's API" do
    test "store error message instead of Quote" do
      err = {:error, "BOOM"}
      expect(HttpClientMock, :get, fn _url, _opts -> err end)

      assert_results(%{"Nokia" => err})
    end
  end
end
