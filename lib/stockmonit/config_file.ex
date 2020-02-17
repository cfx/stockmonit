defmodule Stockmonit.ConfigFile do
  @moduledoc """
  Loads and parses .stockmonit.json file.
  """
  @behaviour Stockmonit.ConfigReader
  @filename ".stockmonit.json"

  alias Stockmonit.{Config, Stock, Provider}

  def read() do
    case File.read(config_path()) do
      {:ok, body} ->
        body
        |> Poison.decode()
        |> handle_json_decode()

      {:error, _} ->
        {:error, "Can't load #{@filename}"}
    end
  end

  defp handle_json_decode({:error, _}), do: {:error, "Invalid #{@filename}"}

  defp handle_json_decode({:ok, data}) do
    config = %Config{
      stocks: col_to_struct(data["stocks"], Stock),
      providers: col_to_struct(data["providers"], Provider)
    }

    {:ok, config}
  end

  defp col_to_struct(col, obj) do
    Enum.map(col, fn el ->
      stct =
        Enum.reduce(el, %{}, fn {k, v}, acc ->
          Map.put(acc, String.to_existing_atom(k), v)
        end)

      struct(obj, stct)
    end)
  end

  defp config_path() do
    System.user_home() <> "/#{@filename}"
  end
end
