use Mix.Config

config :stockmonit, :children, [
  Stockmonit.StockSupervisor,
  Stockmonit.Server
]
