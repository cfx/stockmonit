defmodule Stockmonit.ConfigTest do
  use ExUnit.Case
  doctest Stockmonit.Config
  alias Stockmonit.{Config, ConfigMock}

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  test "stops process when config file returns an error" do
    Process.flag(:trap_exit, true)
    expect(ConfigMock, :read, fn -> {:error, "boom"} end)

    assert {:error, "boom"} = Config.start_link(:no_args)
  end

  describe "get()" do
    test "returns config map taken from config reader" do
      cfg = %{
        "stocks" => [],
        "config" => %{
          "api_key" => "secret",
          "api" => "Mock",
          "interval" => 0
        }
      }

      expect(ConfigMock, :read, fn -> {:ok, cfg} end)
      start_supervised(Config)

      assert Config.get() == cfg
    end
  end
end
