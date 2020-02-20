defmodule Stockmonit.Config.FileTest do
  use ExUnit.Case
  doctest Stockmonit.Config.File
  alias Stockmonit.Config
  alias Config.{Stock, Provider}

  test "returns an error when config file cannot be found" do
    path = TestHelper.fixture("non_existing_file")
    assert Config.File.read(path) == {:error, "Can't load config file"}
  end

  test "returns an error when config file is invalid json" do
    path = TestHelper.fixture("invalid_stockmonit.json")
    assert Config.File.read(path) == {:error, "Invalid config file"}
  end

  test "returns %Config when config file is valid" do
    path = TestHelper.fixture("valid_stockmonit.json")

    expected = %Config{
      stocks: [
        %Stock{
          name: "Nokia",
          symbol: "NOK",
          api: "Finnhub"
        }
      ],
      providers: [
        %Provider{
          name: "Finnhub",
          api_key: "secret",
          interval: 60
        }
      ]
    }

    assert Config.File.read(path) == {:ok, expected}
  end
end
