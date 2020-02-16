defmodule Stockmonit.Results do
  use GenServer

  def init(:no_args), do: {:ok, %{}}

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def put(key, val) do
    GenServer.cast(__MODULE__, {:put, key, val})
  end

  def handle_call(:get, _from, data) do
    {:reply, data, data}
  end

  def handle_cast({:put, key, val}, data) do
    {:noreply, Map.put(data, key, val)}
  end
end
