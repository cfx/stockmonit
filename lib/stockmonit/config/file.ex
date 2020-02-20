defmodule Stockmonit.Config.File do
  @moduledoc """
  Reads config file from $HOME/.stockmonit.json and
  converts it into %Stockmonit.Config struct
  """
  alias Stockmonit.{Config}
  alias Config.{Stock, Provider}

  @behaviour Config.Reader

  @impl Config.Reader
  def read(path) do
    case File.read(path) do
      {:ok, body} ->
        create_from_json(body)

      {:error, _} ->
        {:error, "Can't load config file"}
    end
  end

  @doc ~S'''
  Creates %Config struct from json file. Every api which is
  not implemented in Stockmonit.Api.<ProviderModule> is being removed.

  ## Examples
      iex> json = """
      ...>{
      ...>   "providers": [
      ...>       {
      ...>           "name": "Finnhub",
      ...>           "api_key": "secret",
      ...>           "interval": 60
      ...>       },
      ...>       {
      ...>           "name": "NotImplemented",
      ...>           "api_key": "secret",
      ...>           "interval": 60
      ...>       }
      ...>   ],
      ...>
      ...>   "stocks": [
      ...>       {
      ...>           "name": "Foo",
      ...>           "symbol": "FOO",
      ...>           "api": "Finnhub"
      ...>       },
      ...>       {
      ...>           "name": "Bar",
      ...>           "symbol": "BAR",
      ...>           "api": "NotImplemented"
      ...>       }
      ...>   ]
      ...>}
      ...>"""
      iex> Stockmonit.Config.File.create_from_json(json)
      {:ok,
       %Stockmonit.Config{
         providers: [
           %Stockmonit.Config.Provider{api_key: "secret", interval: 60, name: "Finnhub"}
         ],
         stocks: [
           %Stockmonit.Config.Stock{api: "Finnhub", name: "Foo", symbol: "FOO"},
           %Stockmonit.Config.Stock{api: "NotImplemented", name: "Bar", symbol: "BAR"}
         ]
      }}
  '''

  @spec create_from_json(String.t()) :: Config.Reader.t()
  def create_from_json(json_str) do
    case Poison.decode(json_str) do
      {:ok, data} ->
        config = %Config{
          stocks: data["stocks"] |> to_struct(Stock),
          providers:
            data["providers"]
            |> to_struct(Provider)
            |> Enum.filter(fn %Provider{name: name} ->
              Provider.implemented?(name)
            end)
        }

        {:ok, config}

      {:error, _} ->
        {:error, "Invalid config file"}
    end
  end

  defp to_struct(col, model) do
    Enum.map(col, fn el ->
      obj =
        Enum.reduce(el, %{}, fn {k, v}, acc ->
          Map.put(acc, String.to_existing_atom(k), v)
        end)

      struct(model, obj)
    end)
  end
end
