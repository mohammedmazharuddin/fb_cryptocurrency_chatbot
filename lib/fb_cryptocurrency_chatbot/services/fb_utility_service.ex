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
  alias FbCryptocurrencyChatbot.Templates
  require Logger

  @page_token Application.get_env(:fb_cryptocurrency_chatbot, :fb_creds)[:page_token]

  @spec fetch_user_name(String.t) :: [FbCryptocurrencyChatbot.Username.t]

  def fetch_user_name(sender) do
    query = "access_token=#{@page_token}&fields=name"
    url = "https://graph.facebook.com/v13.0/#{sender}?#{query}"
    with \
      {:ok, resp} <- HttpUtility.request(:get, url, "", [])
    do
      user = resp.body |> Poison.decode! |> string_keys_to_atoms
      {:ok, Map.merge(%FbCryptocurrencyChatbot.Username{}, user)}
    else
      resp -> resp
    end
  end

  def send_button_options(type, text, buttons_list, recipient) do
    url = "https://graph.facebook.com/v13.0/me/messages?access_token=#{@page_token}"
    with \
      {:ok, template} <- Templates.fetch_button_template(type, text, buttons_list, recipient) |> IO.inspect(label: "yes please"),
      {:ok, resp} <- HttpUtility.request(:post, url, Poison.encode!(template), [{"Content-Type", "application/json"}])
    do
      Logger.info("Button options sent!")
      {:ok, resp}
    end
  end

  def string_keys_to_atoms(string_map), do: string_map |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
end