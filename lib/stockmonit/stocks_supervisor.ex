defmodule Stockmonit.StocksSupervisor do
  use DynamicSupervisor
  alias Stockmonit.Config.{Stock, Provider}

  alias Stockmonit.StockWorker

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @spec add_stock(Stock.t(), Provider.t() | nil) :: {:ok, pid()}
  def add_stock(stock, provider) do
    child_spec = %{
      id: StockWorker,
      start: {StockWorker, :start_link, [stock, provider]}
    }

    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
