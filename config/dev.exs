use Mix.Config

config :stockmonit, :children, [
  Stockmonit.StockSupervisor,
  Stockmonit.Server,
  {Ratatouille.Runtime.Supervisor,
   runtime: [
     app: Stockmonit.View,
     shutdown: {:application, :stockmonit}
   ]}
]
