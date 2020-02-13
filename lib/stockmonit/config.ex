defmodule Stockmonit.Config do
  @moduledoc """
  Documentation for `Stockmonit`.
  """

  def load(filename) do
    config =
      filename
      |> config_path()
      |> File.read()

    case config do
      {:ok, body} ->
        body
        |> Poison.decode()
        |> handle_json_decode()

      {:error, _} ->
        {:error, "Can't load #{filename}"}
    end
  end

  defp handle_json_decode({:error, _}), do: {:error, "Invalid config file"}
  defp handle_json_decode(res), do: res

  defp config_path(filename) do
    System.user_home() <> "/#{filename}"
  end
end
