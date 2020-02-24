defmodule Stockmonit.DefaultHttpClient do
  @behaviour Stockmonit.HttpClient

  @impl Stockmonit.HttpClient
  def get(url, _opts \\ %{}) do
    url
    |> HTTPoison.get()
    |> handle_response
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}), do: {:ok, body}

  defp handle_response({_, %{status_code: sc, body: body}}) do
    {:error, "API error: status: #{sc} '#{body}'"}
  end

  defp handle_response({:error, err = %HTTPoison.Error{id: nil, reason: reason}}) do
    {:error, "Error: #{inspect(reason)}"}
  end
end
