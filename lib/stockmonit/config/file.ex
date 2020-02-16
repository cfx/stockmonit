defmodule Stockmonit.Config.File do
  @moduledoc """
  Loads and parses .stockmonit.json file.
  """
  @behaviour Stockmonit.Config.Reader
  @filename ".stockmonit.json"

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
  defp handle_json_decode(res), do: res

  defp config_path() do
    System.user_home() <> "/#{@filename}"
  end
end
