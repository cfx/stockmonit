defmodule Stockmonit.Stock do
  def monitor(%{"name" => name, "symbol" => symbol, "api" => api, "interval" => interval}) do
    find_api(api)
  end

  def api_implement?(api) do
    ("Elixir.Stockmonit.Apis." <> api)
    |> String.to_atom()
    |> Code.ensure_compiled?()
  end
end
