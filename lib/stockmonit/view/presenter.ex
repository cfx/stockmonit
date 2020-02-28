defmodule Stockmonit.View.Presenter do
  alias Stockmonit.Quote
  @type column_props :: [content: String.t(), color: atom()]

  @doc """
  Rounds price to 2 decimal places and sets text color.
  """

  @spec price_column(Quote.price()) :: column_props()
  def price_column(value) do
    [content: to_str(value), color: :default]
  end

  @doc """
  Sets text color for 'Current' column. If current price is
  higher than close price show in green. If lower then in red,
  otherwise default.
  """

  @spec current_price_column(Quote.price(), Quote.price()) :: column_props()
  def current_price_column(current_price, close_price)
      when current_price > close_price do
    [content: to_str(current_price), color: :green]
  end

  def current_price_column(current_price, close_price)
      when current_price < close_price do
    [content: to_str(current_price), color: :red]
  end

  def current_price_column(current_price, _), do: price_column(current_price)

  @doc """
  Shows price change in percentage (compared to purchase_price defined
  in stockmonit.json file
  """
  @spec change_column(Quote.price() | nil) :: column_props()
  def change_column(val) when is_nil(val) or val == 0 do
    [content: "-", color: :default]
  end

  def change_column(val) when val > 100 do
    [content: to_str(val - 100), color: :green]
  end

  def change_column(val) when val < 100 do
    [content: to_str(-1 * (100.0 - val)), color: :red]
  end

  @spec to_str(Quote.price()) :: String.t()
  defp to_str(val) when is_integer(val), do: Integer.to_string(val)

  defp to_str(val) when is_float(val) do
    val
    |> Float.floor(2)
    |> Float.to_string()
  end
end
