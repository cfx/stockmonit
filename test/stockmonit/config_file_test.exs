defmodule Stockmonit.ConfigFileTest do
  use ExUnit.Case
  doctest Stockmonit.ConfigFile
  alias Stockmonit.{ConfigFile, Config}
  alias Config.{Stock, Provider}

  test "returns an error when config file cannot be found" do
    path = Path.join(TestHelper.fixtures_dir(), "non_existing_file")
    assert ConfigFile.read(path) == {:error, "Can't load config file"}
  end

  test "returns an error when config file is invalid json" do
    path = Path.join(TestHelper.fixtures_dir(), "invalid_stockmonit.json")
    assert ConfigFile.read(path) == {:error, "Invalid config file"}
  end

  test "returns %Config when config file is valid" do
    path = Path.join(TestHelper.fixtures_dir(), "valid_stockmonit.json")

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

    assert ConfigFile.read(path) == {:ok, expected}
  end
end
