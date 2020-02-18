use Mix.Config

config :stockmonit, :children, [
  Stockmonit.Results,
  Stockmonit.StocksSupervisor,
  {Stockmonit.ConfigServer, System.user_home() |> Path.join("/.stockmonit.json")},
  {Ratatouille.Runtime.Supervisor,
   runtime: [
     app: Stockmonit.View,
     shutdown: {:application, :stockmonit}
   ]}
]

config :stockmonit, :config_reader, Stockmonit.ConfigFile
