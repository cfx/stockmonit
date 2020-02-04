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
        IO.puts("Can't load #{path} file")
        System.halt(2)
    end
  end

  defp parse_config(json_str) do
    case Poison.decode(json_str) do
      {:ok, data} ->
        data

      {:error, _} ->
        IO.puts("Invalid #{@config_filename}")
        System.halt(2)
    end
  end

  defp monitor_stocks(%{"stocks" => stocks}) do
    for stock <- stocks do
      Stockmonit.Stock.monitor(stock)
    end
  end

  defp config_path() do
    System.user_home() <> "/#{@config_filename}"
  end
end
