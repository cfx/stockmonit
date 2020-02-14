defmodule Stockmonit.StockSupervisor do
  use DynamicSupervisor

  alias Stockmonit.StockWorker

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_stock(stock, config) do
    child_spec = %{
      id: StockWorker,
      start: {StockWorker, :start_link, [stock, config]}
    }

    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
