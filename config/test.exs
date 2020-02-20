use Mix.Config

config :stockmonit, :config_reader, Stockmonit.ConfigServerMock
config :stockmonit, :http_client, Stockmonit.HttpClientMock
config :stockmonit, :api_fetch_interval, 1000
