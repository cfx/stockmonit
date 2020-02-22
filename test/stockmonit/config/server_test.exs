defmodule Stockmonit.Config.ServerTest do
  use ExUnit.Case
  doctest Stockmonit.Config.Server
  alias Stockmonit.Config.{Server}

  test "stops process when config file returns an error" do
    Process.flag(:trap_exit, true)
    expected = {:error, "Can't load config file"}
    assert ^expected = Server.start_link("/invalid/path")
  end
end
