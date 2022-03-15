defmodule FbCryptocurrencyChatbotWeb.WebHookController do
  use FbCryptocurrencyChatbotWeb, :controller
  require Logger
  alias FbCryptocurrencyChatbot.MessageActionService

  @verify_token Application.get_env(:fb_cryptocurrency_chatbot, :fb_creds)[:verify_token]

  def verify_token(
        conn,
        %{"hub.challenge" => challenge, "hub.mode" => _mode, "hub.verify_token" => verify_token} =
          _params
      ) do
    if verify_token == @verify_token do
      Logger.notice("Webhook Verified")
      send_resp(conn, 200, challenge)
    else
      Logger.error("Mismatch Token. Verification Failed")
      send_resp(conn, 403, "")
    end
  end

  def verify_token(conn, _params), do: send_resp(conn, 403, "")

  def process_events(conn, params) do
    if conn.body_params["object"] == "page" do
      conn.body_params["entry"]
      |> Enum.each(fn entry ->
        entry["messaging"]
        |> Enum.each(&MessageActionService.perform_message_action(&1))
      end)
    end

    send_resp(conn, 200, "")
  end
end
