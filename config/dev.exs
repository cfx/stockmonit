use Mix.Config

config :stockmonit, :children, [
  Stockmonit.Results,
  Stockmonit.StocksSupervisor,
  Stockmonit.Config,
  {Ratatouille.Runtime.Supervisor,
   runtime: [
     app: Stockmonit.View,
     shutdown: {:application, :stockmonit}
   ]}
]

config :stockmonit, :config_reader, Stockmonit.Config.File
