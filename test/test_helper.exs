Application.load(:stockmonit)

for app <- Application.spec(:stockmonit, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()

defmodule TestHelper do
  def fixtures_dir, do: Path.join([File.cwd!(), "test", "fixtures"])
end

Mox.defmock(Stockmonit.ConfigServerMock, for: Stockmonit.Config.Reader)
Mox.defmock(Stockmonit.HttpClientMock, for: Stockmonit.HttpClient)
