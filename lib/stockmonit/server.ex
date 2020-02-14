defmodule Stockmonit.Server do
  use GenServer

  def start_link(config_filename) do
    GenServer.start_link(__MODULE__, config_filename, name: __MODULE__)
  end

  def get_data() do
    GenServer.call(__MODULE__, :get_data)
  end

  def put_data(key, val) do
    GenServer.cast(__MODULE__, {:put_data, key, val})
  end

  def handle_call(:get_data, _from, data) do
    {:reply, data, data}
  end

  def handle_cast({:put_data, key, val}, data) do
    {:noreply, Map.put(data, key, val)}
  end

  def handle_info(:monitor_stocks, config = %{"stocks" => stocks, "config" => api_config}) do
    stocks |> Enum.each(&Stockmonit.StockSupervisor.add_stock(&1, api_config))
    {:noreply, %{}}
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
