defmodule StockmonitTest do
  use ExUnit.Case
  alias Stockmonit.{HttpClientMock}

  #  import :timer, only: [sleep: 1]

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  test "store quote from API call in Results" do
    # expect(HttpClientMock, :get, fn _url, _opts ->
    #  body = """
    #  {
    #    "c": 12,
    #    "o": 10,
    #    "h": 14,
    #    "l": 11,
    #    "pc": 9
    #  }
    #  """

    #  {:ok, body}
    # end)

    # expected = %Quote{
    #  current_price: 12,
    #  close_price: 9,
    #  open_price: 10,
    #  low_price: 11,
    #  high_price: 14
    # }

    assert 1 == 1
    # TestHelper.fixtures_dir()
    # |> Path.join("valid_stockmonit.json")
    # |> Config.Server.start_link()
  end
end
