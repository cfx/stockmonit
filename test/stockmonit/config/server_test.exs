defmodule Stockmonit.Config.ServerTest do
  use ExUnit.Case
  doctest Stockmonit.Config.Server
  alias Stockmonit.Config

  #  import :timer, only: [sleep: 1]

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  describe "When config file can't be found" do
    test "stops process when config file returns an error" do
      Process.flag(:trap_exit, true)
      expected = {:error, "Can't load config file"}
      assert ^expected = Config.Server.start_link("/invalid/path")
    end
  end
end
