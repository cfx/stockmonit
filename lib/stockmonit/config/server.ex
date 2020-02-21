defmodule Stockmonit.Config.Server do
  use GenServer
  alias Stockmonit.Config

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
  def get_providers(), do: GenServer.call(__MODULE__, :get_providers)

  def handle_call(:get, _from, config), do: {:reply, config, config}

  def handle_call(:get_providers, _from, cfg = %Config{providers: providers}) do
    {:reply, providers, cfg}
  end

  def handle_info(:init_stocks, config) do
    %Config{stocks: stocks} = config
    Enum.each(stocks, &Stockmonit.StocksSupervisor.add_stock(&1))
    {:noreply, config}
  end

  defp config_reader() do
    Application.get_env(:stockmonit, :config_reader)
  end
end
