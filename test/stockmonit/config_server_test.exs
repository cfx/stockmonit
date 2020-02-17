defmodule Stockmonit.ConfigServerTest do
  use ExUnit.Case
  doctest Stockmonit.ConfigServer
  alias Stockmonit.{ConfigServer, ConfigServerMock, Config, Provider}

  #  import :timer, only: [sleep: 1]

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  test "stops process when config file returns an error" do
    Process.flag(:trap_exit, true)
    expect(ConfigServerMock, :read, fn -> {:error, "boom"} end)

    assert {:error, "boom"} = ConfigServer.start_link(:no_args)
  end

  describe "get()" do
    test "returns config map taken from config reader" do
      cfg = %Config{
        stocks: [],
        providers: [
          %Provider{
            name: "Mock",
            api_key: "secret",
            interval: 0
          }
        ]
      }

      expect(ConfigServerMock, :read, fn -> {:ok, cfg} end)
      start_supervised(ConfigServer)
      assert ConfigServer.get() == cfg
    end
  end
end
