defmodule Stockmonit.Api do
  def monitor(stock, %{"api" => api_provider, "api_key" => api_key}) do
    case implemented(api_provider) do
      {:error, _} -> "not implemented"
      {:module, api} -> api.fetch(stock, api_key)
    end
  end

  @doc """
  Checks if module for given provider is implemented.

  ## Examples

      iex> Stockmonit.Api.implemented("NotImplemented")
      {:error, :nofile}

      iex> Stockmonit.Api.implemented("Finnhub")
      {:module, Stockmonit.Api.Finnhub}
  """

  def implemented(api_provider) do
    ("Elixir.Stockmonit.Api." <> api_provider)
    |> String.to_atom()
    |> Code.ensure_compiled()
  end
end
