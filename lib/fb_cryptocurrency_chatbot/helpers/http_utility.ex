defmodule FbCryptocurrencyChatbot.HttpUtility do
  
  @moduledoc """
  performs http operations
  """
  require Logger

  def request(method, url, params, headers, options \\ [])
  def request(:post, url, params, headers, options) do
    HTTPoison.post(url, params, headers, options)
    |> parse_response()
  end

  def request(:get, url, _, headers, options) do
    HTTPoison.get(url, headers, options)
    |> parse_response()
  end

  def request(method, url, body, headers, options) do
    HTTPoison.request(method, url, body, headers, options)
    |> parse_response()
  end

  defp parse_response({:ok, %HTTPoison.Response{} = response}) do
    case response.status_code do
      status when status in 200..204 -> {:ok, response}
      404 -> {:error, :not_found}
      422 -> {:error, :unprocessable_entity, Poison.decode!(response.body)}
      _ -> {:error, :unprocessable_entity}
    end
  end

  defp parse_response({:error, reason}) do
    {:error, :unprocessable_entity, reason}
  end
end
