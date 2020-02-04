defmodule Stockmonit do
  @config_filename ".stockmonit.json"

  @moduledoc """
  Documentation for `Stockmonit`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Stockmonit.hello()
      :world

  """
  def hello do
    :world
  end

  def main() do
    config_path()
    |> load_config
    |> parse_config
    |> monitor_stocks
  end

  defp load_config(path) do
    case File.open(path) do
      {:ok, body} ->
        IO.read(body, :all)

      {:error, _} ->
        halt("Can't load #{path} file")
    end
  end

  defp parse_config(json_str) do
    case Poison.decode(json_str) do
      {:ok, data} ->
        data

      {:error, _} ->
        halt("Invalid #{@config_filename}")
    end
  end

  defp monitor_stocks(%{"stocks" => stocks, "config" => config}) do
    for stock <- stocks do
      Stockmonit.Api.monitor(stock, config)
    end
  end

  defp config_path() do
    System.user_home() <> "/#{@config_filename}"
  end

  defp halt(msg) do
    IO.puts(msg)
    System.halt(2)
  end
end
