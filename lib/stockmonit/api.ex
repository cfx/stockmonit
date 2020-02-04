defmodule Stockmonit.Api do
  def monitor(stock, %{"api" => api_provider, "api_key" => api_key}) do
    case implemented(api_provider) do
      :error -> "not implemented"
      api -> api.fetch(stock, api_key)
    end
  end

  @doc """
  Checks if module for given provider is implemented.

  ## Examples

      iex> Stockmonit.Api.implemented("NotImplemented")
      :error

      iex> Stockmonit.Api.implemented("Finnhub")
      Stockmonit.Api.Finnhub
  """

  def implemented(api_provider) do
    compiled =
      ("Elixir.Stockmonit.Api." <> api_provider)
      |> String.to_atom()
      |> Code.ensure_compiled()

    case compiled do
      {:error, _} -> :error
      {:module, api} -> api
    end
  end
end
