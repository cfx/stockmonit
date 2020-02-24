defmodule Stockmonit.Config.Provider do
  defstruct [:api_key, :interval]

  @type t :: %__MODULE__{
          api_key: String.t(),
          interval: integer
        }

  @doc """
  Checks if module for given provider is implemented.

  ## Examples

      iex> Stockmonit.Config.Provider.implemented?("NotImplemented")
      false

      iex> Stockmonit.Config.Provider.implemented?("Finnhub")
      true
  """

  @spec implemented?(String.t()) :: bool
  def implemented?(name) do
    res =
      name
      |> to_atom()
      |> Code.ensure_compiled()

    case res do
      {:error, _} -> false
      _ -> true
    end
  end

  @spec to_atom(String.t()) :: atom()
  def to_atom(name), do: String.to_atom("Elixir.Stockmonit.Api.#{name}")
end
