defmodule Stockmonit.Provider do
  defstruct [:name, :api_key, :interval]
  alias Stockmonit.Provider

  @type t :: %Stockmonit.Provider{
          name: String.t(),
          api_key: String.t(),
          interval: integer
        }

  @doc """
  Checks if module for given provider is implemented.

  ## Examples

      iex> Stockmonit.Provider.implemented("NotImplemented")
      {:error, :nofile}

      iex> Stockmonit.Provider.implemented("Finnhub")
      {:module, Stockmonit.Api.Finnhub}
  """

  def implemented(name) do
    name
    |> to_atom()
    |> Code.ensure_compiled()
  end

  @doc """
  Finds provider by name

  ## Examples

      iex> Stockmonit.Provider.find([%Stockmonit.Provider{name: "Finnhub"}], "Finnhub")
      %Stockmonit.Provider{name: "Finnhub", api_key: nil, interval: nil}

      iex> Stockmonit.Provider.find([%Stockmonit.Provider{name: "Foobar"}], "Finnhub")
      nil
  """

  def find([], _provider_name), do: nil

  def find([provider = %Provider{name: name} | _], provider_name)
      when <<name::bitstring>> == provider_name do
    provider
  end

  def find([_ | t], provider_name), do: find(t, provider_name)

  def to_atom(name), do: String.to_atom("Elixir.Stockmonit.Api.#{name}")
end
