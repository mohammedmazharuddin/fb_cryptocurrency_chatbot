defmodule FbCryptocurrencyChatbot.Username do
  @moduledoc """
  Facebook user structure
  """

  @derive [Poison.Encoder]
  defstruct [:id, :name]

  @type t :: %FbCryptocurrencyChatbot.Username{
    id: String.t,
    name: String.t
  }
end

defmodule FbCryptocurrencyChatbot.FbUtilityService do
  @moduledoc """
  Provides fb utility methods 
  """
  alias FbCryptocurrencyChatbot.HttpUtility
  require Logger

  @page_token Application.get_env(:fb_cryptocurrency_chatbot, :fb_creds)[:page_token]

  @spec fetch_user_name(String.t) :: [FbCryptocurrencyChatbot.Username.t]

  def fetch_user_name(sender) do
    query = "access_token=#{@page_token}&fields=name"
    url = "https://graph.facebook.com/v13.0/#{sender}?#{query}"
    with \
      {:ok, resp} <- HttpUtility.fetch(:get, url, "", [])
    do
      user = resp.body |> Poison.decode! |> string_keys_to_atoms
      {:ok, Map.merge(%FbCryptocurrencyChatbot.Username{}, user)}
    else
      resp -> resp
    end
  end

  def string_keys_to_atoms(string_map), do: string_map |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
end