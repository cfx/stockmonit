defmodule Stockmonit.View.Presenter do
  @type price :: float() | integer()
  @type t :: [content: String.t(), color: atom()]

  @doc """
  Rounds price to 2 decimal places and sets text color.
  """

  @spec price_column(price) :: __MODULE__.t()
  def price_column(value) do
    [content: to_str(value), color: :default]
  end

  @doc """
  Sets text color for 'Current' column. If current price is
  higher than close price show in green. If lower then in red,
  otherwise default.
  """

  @spec current_price_column(price, price) :: __MODULE__.t()
  def current_price_column(current_price, close_price)
      when current_price > close_price do
    [content: to_str(current_price), color: :green]
  end

  def current_price_column(current_price, close_price)
      when current_price < close_price do
    [content: to_str(current_price), color: :red]
  end

  def current_price_column(current_price, _), do: price_column(current_price)

  @spec to_str(price) :: String.t()
  defp to_str(val) when is_integer(val), do: Integer.to_string(val)

  defp to_str(val) when is_float(val) do
    val
    |> Float.floor(2)
    |> Float.to_string()
  end
end
