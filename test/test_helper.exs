Application.load(:stockmonit)

for app <- Application.spec(:stockmonit, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()

defmodule TestHelper do
  def fixture(filename) do
    Path.join([File.cwd!(), "test", "fixtures", filename])
  end
end

Mox.defmock(Stockmonit.ConfigServerMock, for: Stockmonit.Config.Reader)
Mox.defmock(Stockmonit.HttpClientMock, for: Stockmonit.HttpClient)
