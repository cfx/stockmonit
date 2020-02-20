use Mix.Config

config :stockmonit, :config_reader, Stockmonit.Config.File
config :stockmonit, :http_client, Stockmonit.DefaultHttpClient
config :stockmonit, :api_fetch_interval, 1000
