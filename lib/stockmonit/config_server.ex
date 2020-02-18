defmodule Stockmonit.ConfigServer do
  use GenServer

  def init(path) do
    case config_reader().read(path) do
      {:error, msg} ->
        {:stop, msg}

      data ->
        Process.send_after(self(), :init_stocks, 0)
        data
    end
  end

  def start_link(path) do
    GenServer.start_link(__MODULE__, path, name: __MODULE__)
  end

  def get(), do: GenServer.call(__MODULE__, :get)
  def handle_call(:get, _from, config), do: {:reply, config, config}

  def handle_info(:init_stocks, config) do
    %Stockmonit.Config{stocks: stocks, providers: providers} = config
    Enum.each(stocks, &Stockmonit.StocksSupervisor.add_stock(&1, providers))
    {:noreply, config}
  end

  defp config_reader() do
    Application.get_env(:stockmonit, :config_reader)
  end
end
