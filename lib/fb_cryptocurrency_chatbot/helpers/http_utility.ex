defmodule FbCryptocurrencyChatbot.HttpUtility do
  
  @moduledoc """
  performs http operations
  """
  require Logger

  @doc """
  Performs http request based on the method type

    * :method - http method type
    * :url - the message to send
    * :headers - a list of headers
    * :options - a list of options
  """

  @spec request(method :: String.t, url :: String.t, headers :: list, options :: list) :: {atom, HTTPoison.Response.t} | {:error, term}
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

  @doc """
  Parses the http response

    * :response - Httpoison response map
  """
  @spec parse_response(response :: HTTPoison.Response.t) :: {atom, HTTPoison.Response.t} | {:error, term}
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
