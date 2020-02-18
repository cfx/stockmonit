use Mix.Config

config :stockmonit, :children, []
config :stockmonit, :config_reader, Stockmonit.ConfigServerMock
config :stockmonit, :http_client, Stockmonit.HttpClientMock
