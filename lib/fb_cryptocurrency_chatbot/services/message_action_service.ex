defmodule FbCryptocurrencyChatbot.MessageActionService do
  @moduledoc """
  Performs actions based on incoming messages
  """
  alias FbCryptocurrencyChatbot.PostbackHandlerService
  alias FbCryptocurrencyChatbot.MessageHandlerService
  require Logger

  def perform_message_action(%{"message" => message, "recipient" => _recipient, "sender" => %{"id" => sender}} = _event) do
    Logger.info(["message: ", message["text"]])
    MessageHandlerService.handle_message(message["text"], sender)
  end

  def perform_message_action(%{"postback" => postback, "recipient" => _recipient, "sender" => %{"id" => sender}} = _event) do
    Logger.info(["postback: ", postback["payload"]])
    PostbackHandlerService.handle_postback(postback["payload"], sender)
  end
end