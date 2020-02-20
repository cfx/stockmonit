use Mix.Config

# config :stockmonit, :config_reader, Stockmonit.ConfigServerMock
config :stockmonit, :config_reader, Stockmonit.Config.File
config :stockmonit, :http_client, Stockmonit.HttpClientMock
config :stockmonit, :api_fetch_interval, 0
