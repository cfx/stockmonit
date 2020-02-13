defmodule Stockmonit.Server do
  use GenServer

  def start_link(config_filename) do
    GenServer.start_link(__MODULE__, config_filename, name: __MODULE__)
  end

  def get_config() do
    GenServer.call(__MODULE__, :get_config)
  end

  def handle_call(:get_config, _from, config) do
    {:reply, config, config}
  end

  def handle_info(:monitor_stocks, config = %{"stocks" => stocks, "config" => api_config}) do
    stocks |> Enum.each(&Stockmonit.StockSupervisor.add_stock(&1, api_config))
    {:noreply, config}
  end

  def init(config_filename) do
    case Stockmonit.Config.load(config_filename) do
      {:error, msg} ->
        {:stop, msg}

      config ->
        Process.send_after(self(), :monitor_stocks, 0)
        config
    end
  end
end
