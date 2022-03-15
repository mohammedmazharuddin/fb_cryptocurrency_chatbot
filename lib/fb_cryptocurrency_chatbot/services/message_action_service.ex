defmodule FbCryptocurrencyChatbot.MessageActionService do
  @moduledoc """
  Performs actions based on incoming messages
  """
  alias FbCryptocurrencyChatbot.MessageSender
  alias FbCryptocurrencyChatbot.PostbackHandlerService
  require Logger

  def perform_message_action(%{"message" => message, "recipient" => recipient, "sender" => sender} = _event) do
    Logger.info(["message: ", message["text"]])
  end

  def perform_message_action(%{"postback" => postback, "recipient" => _recipient, "sender" => %{"id" => sender}} = _event) do
    Logger.info(["postback: ", postback["payload"]])
    PostbackHandlerService.handle_postback(postback["payload"], sender)
  end
end