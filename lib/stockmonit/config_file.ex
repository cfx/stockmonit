defmodule Stockmonit.ConfigFile do
  @moduledoc """
  Reads config file from $HOME/.stockmonit.json and
  converts it into %Stockmonit.Config struct
  """
  @behaviour Stockmonit.ConfigReader

  alias Stockmonit.{Config, Stock, Provider}

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
      iex> Stockmonit.ConfigFile.create_from_json(json)
      {:ok,
       %Stockmonit.Config{
         providers: [
           %Stockmonit.Provider{api_key: "secret", interval: 60, name: "Finnhub"}
         ],
         stocks: [
           %Stockmonit.Stock{api: "Finnhub", name: "Foo", symbol: "FOO"},
           %Stockmonit.Stock{api: "NotImplemented", name: "Bar", symbol: "BAR"}
         ]
      }}
  '''

  def create_from_json(json_str) do
    case Poison.decode(json_str) do
      {:ok, data} ->
        config = %Config{
          stocks: data["stocks"] |> to_struct(Stock),
          providers:
            data["providers"]
            |> to_struct(Provider)
            |> sanitize_providers
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

  defp sanitize_providers([]), do: []

  defp sanitize_providers([p = %Provider{name: name} | providers]) do
    case Provider.implemented(name) do
      {:error, _} -> sanitize_providers(providers)
      _ -> [p | sanitize_providers(providers)]
    end
  end
end
