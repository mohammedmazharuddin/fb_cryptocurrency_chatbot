defmodule FbCryptocurrencyChatbot.PostbackHandlerService do
  @moduledoc """
  Performs actions based on incoming messages
  """
  alias FbCryptocurrencyChatbot.MessageSender
  alias FbCryptocurrencyChatbot.FbUtilityService
  alias FbCryptocurrencyChatbot.CoinGeckoService
  require Logger

  def handle_postback("WELCOME", recipient) do
    text = "To search for coins, please use the options below. Search coins by"
    buttons_list = [{"Name", "COINS_BY_NAME"}, {"ID", "COINS_BY_ID"}]

    with \
      {:ok, username} <- FbUtilityService.fetch_user_name(recipient),
      {:ok, _resp} <- MessageSender.send(recipient, "Hello #{username.name}. Welcome to the world of crypto currency. We will assist you in finding the coins."),
      {:ok, _resp} <- FbUtilityService.send_button_options("postback", text, buttons_list, recipient)
      do
        :ok
    else
      _any -> Logger.error("Failed to handle 'WELCOME' postback.")
    end
  end

  def handle_postback("COINS_BY_ID", recipient) do
    with \
      {:ok, coins} <- CoinGeckoService.fetch_coins(),
      {:ok, _resp} <- FbUtilityService.send_generic_buttons_options("postback", "Select", coins, recipient) 
    do
      :ok
    else
      _any -> Logger.error("Failed to handle 'COINS_BY_ID' postback.")
    end
  end

  def handle_postback("COINS_BY_NAME", recipient) do
    with \
      {:ok, coins} <- CoinGeckoService.fetch_coins(),
      {:ok, _resp} <- FbUtilityService.send_generic_buttons_options("postback", "Select", coins, recipient) 
    do
      :ok
    else
      _any -> Logger.error("Failed to handle 'COINS_BY_NAME' postback.")
    end
  end

  def handle_postback(postback, recipient) do
    cond do
      String.contains? postback, "GET_COIN_PRICE" ->
        with \
          [_payload, coin_id] <- String.split(postback, "/"),
          {:ok, prices_list} <- CoinGeckoService.fetch_coin_price(coin_id)
        do
          prices_list
          |> Enum.each(& MessageSender.send(recipient, &1))
          :ok
        else
          _any -> Logger.error("Failed to handle 'GET_COIN_PRICE' postback.")
        end
      true -> Logger.notice(["Unhandled postback: ", postback])
    end
  end
end
