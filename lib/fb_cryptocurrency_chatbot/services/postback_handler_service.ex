defmodule FbCryptocurrencyChatbot.PostbackHandlerService do
  @moduledoc """
  Performs actions based on incoming messages
  """
  alias FbCryptocurrencyChatbot.MessageSender
  alias FbCryptocurrencyChatbot.FbUtilityService
  require Logger

  def handle_postback("WELCOME", recipient) do
    with \
      {:ok, username} <- FbUtilityService.fetch_user_name(recipient),
      {:ok, _resp} <- MessageSender.send(recipient, "Hello #{username.name}. Welcome to the world of crypto currency. We will assist you in finding the coins.")
    do
      :ok
    else
      _any -> Logger.error("Failed to handle 'WELCOME' postback.")
    end
  end

  def handle_postback(postback, recipient) do
    Logger.notice(["Unhandled postback: ", postback])

    :ok
  end
end