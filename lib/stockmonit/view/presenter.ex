defmodule Stockmonit.View.Presenter do
  @type t :: [content: String.t(), color: atom()]

  @doc """
  Rounds price to 2 decimal places and sets text color.
  If price is equal 0, "-" string is returned.
  """

  @spec price_column(float()) :: __MODULE__.t()
  def price_column(value) do
    [content: to_str(value), color: :default]
  end

  @doc """
  Sets text color for 'Current' column. If current price is
  higher show price in green, lower in red, otherwise default.
  """

  @spec current_price_column(float(), float()) :: __MODULE__.t()
  def current_price_column(current_price, close_price)
      when current_price > close_price do
    [content: to_str(current_price), color: :green]
  end

  def current_price_column(current_price, close_price)
      when current_price < close_price do
    [content: to_str(current_price), color: :red]
  end

  def current_price_column(current_price, _), do: price_column(current_price)

  @spec to_str(float()) :: String.t()
  defp to_str(0), do: "-"

  defp to_str(value) do
    value
    |> Float.floor(2)
    |> Float.to_string()
  end
end
