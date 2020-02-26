defmodule Stockmonit.Results do
  use Agent
  alias Stockmonit.Quote

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec put(String.t(), {:ok, Quote.t()} | {:error, String.t()}) :: atom()
  def put(key, val) do
    Agent.update(__MODULE__, fn data ->
      Map.put(data, key, val)
    end)
  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end
end
