use Mix.Config

config :stockmonit, :children, [
  Stockmonit.Results,
  Stockmonit.StocksSupervisor,
  {Stockmonit.Config.Server, System.user_home() |> Path.join("/.stockmonit.json")},
  {Ratatouille.Runtime.Supervisor,
   runtime: [
     app: Stockmonit.View,
     shutdown: {:application, :stockmonit}
   ]}
]

config :stockmonit, :config_reader, Stockmonit.Config.File
config :stockmonit, :http_client, Stockmonit.DefaultHttpClient
config :stockmonit, :api_fetch_interval, 1000
