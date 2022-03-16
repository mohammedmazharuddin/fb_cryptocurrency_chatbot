defmodule FbCryptocurrencyChatbot.MessageHandlerService do
  @moduledoc """
  Performs actions based on incoming messages
  """
  require Logger

  def handle_message(message, recipient) do
    Logger.notice(["Unhandled message: ", message])
  end
end
