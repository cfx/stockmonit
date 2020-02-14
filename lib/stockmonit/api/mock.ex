defmodule Stockmonit.Api.Mock do
  def fetch(_symbol, api_key) do
    mock = %{
      "c" => rand_n(),
      "h" => rand_n(),
      "l" => rand_n(),
      "o" => rand_n(),
      "pc" => rand_n()
    }

    {:ok, map(mock)}
  end

  defp rand_n(), do: Enum.random(1..1000) / 100

  defp map(obj) do
    %{
      "c" => current_price,
      "o" => open_price,
      "h" => high_price,
      "l" => low_price,
      "pc" => close_price
    } = obj

    %{
      "current_price" => current_price,
      "close_price" => close_price,
      "open_price" => open_price,
      "low_price" => low_price,
      "high_price" => high_price
    }
  end
end
