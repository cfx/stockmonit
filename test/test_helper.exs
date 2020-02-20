ExUnit.start()

defmodule TestHelper do
  def fixtures_dir, do: Path.join([File.cwd!(), "test", "fixtures"])
end

Mox.defmock(Stockmonit.ConfigServerMock, for: Stockmonit.Config.Reader)
Mox.defmock(Stockmonit.HttpClientMock, for: Stockmonit.HttpClient)
