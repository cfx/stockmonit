defmodule Stockmonit.Config.ServerTest do
  use ExUnit.Case
  doctest Stockmonit.Config.Server
  alias Stockmonit.{ConfigServerMock, Config}

  #  import :timer, only: [sleep: 1]

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  test "stops process when config file returns an error" do
    Process.flag(:trap_exit, true)
    expect(ConfigServerMock, :read, fn _path -> {:error, "boom"} end)

    assert {:error, "boom"} = Config.Server.start_link("/path/to/config/file")
  end

  describe "get()" do
    test "returns config map taken from config reader" do
      cfg = %Config{
        stocks: [],
        providers: [
          %Config.Provider{
            name: "Mock",
            api_key: "secret",
            interval: 0
          }
        ]
      }

      expect(ConfigServerMock, :read, fn _path -> {:ok, cfg} end)
      start_supervised({Config.Server, "/path/to/config/file"})
      assert Config.Server.get() == cfg
    end
  end
end
