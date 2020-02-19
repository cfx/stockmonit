defmodule Stockmonit.Config.Provider do
  defstruct [:name, :api_key, :interval]
  alias Stockmonit.Config.Provider

  @type t :: %__MODULE__{
          name: String.t(),
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

  @doc """
  Finds provider by name

  ## Examples

      iex> Stockmonit.Config.Provider.find([%Stockmonit.Config.Provider{name: "Finnhub"}], "Finnhub")
      %Stockmonit.Config.Provider{name: "Finnhub", api_key: nil, interval: nil}

      iex> Stockmonit.Config.Provider.find([%Stockmonit.Config.Provider{name: "Foobar"}], "Finnhub")
      nil
  """

  @spec find([Provider.t()], String.t()) :: Provider.t() | nil
  def find([], _provider_name), do: nil

  def find([provider = %Provider{name: name} | _], provider_name)
      when <<name::bitstring>> == provider_name do
    provider
  end

  def find([_ | t], provider_name), do: find(t, provider_name)

  def to_atom(name), do: String.to_atom("Elixir.Stockmonit.Api.#{name}")
end
