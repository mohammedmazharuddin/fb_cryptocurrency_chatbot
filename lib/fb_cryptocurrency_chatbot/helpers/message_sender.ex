defmodule FbCryptocurrencyChatbot.MessageSender do
  @moduledoc """
  Module responsible for communicating back to facebook messenger
  """
  require Logger
  alias FbCryptocurrencyChatbot.HttpUtility

  @page_token Application.get_env(:fb_cryptocurrency_chatbot, :fb_creds)[:page_token]
  
  @doc """
  sends a message to the the recepient

    * :recepient - the recepient to send the message to
    * :message - the message to send
  """

  @spec send(String.t, String.t) :: HTTPotion.Response.t
  def send(recepient, message) do
    with \
      {:ok, resp} <- HttpUtility.request(:post, url(), json_payload(recepient, message), [{"Content-Type", "application/json"}])
    do
      Logger.info("response from FB #{inspect(resp)}")
      {:ok, resp}
    else
      resp ->
        Logger.error("Failed to send the message!")
        resp
    end
  end

  @doc """
  creates a payload to send to facebook

    * :recepient - the recepient to send the message to
    * :message - the message to send
  """
  def payload(recepient, message) do
    %{
      recipient: %{id: recepient},
      message: %{text: message}
    }
  end

  @doc """
  creates a json payload to send to facebook

    * :recepient - the recepient to send the message to
    * :message - the message to send
  """
  def json_payload(recepient, message) do
    payload(recepient, message)
    |> Poison.encode
    |> elem(1)
  end

  @doc """
  return the url to hit to for sending message
  """
  def url do
    query = "access_token=#{@page_token}"
    "https://graph.facebook.com/v13.0/me/messages?#{query}"
  end
end
