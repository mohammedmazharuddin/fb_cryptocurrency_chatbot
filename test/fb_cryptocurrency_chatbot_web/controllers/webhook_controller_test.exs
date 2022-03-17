defmodule FbCryptocurrencyChatbotWeb.WebHookControllerTest do
  use FbCryptocurrencyChatbotWeb.ConnCase

  test "GET /webhook without query", %{conn: conn} do
    conn = get conn, "/webhook"
    assert conn.status == 403
    assert conn.resp_body == ""
  end

  test "GET /webhook with query", %{conn: conn} do
    conn = get conn, "/webhook?hub.mode=subscribe&hub.challenge=914942744&hub.verify_token=sdfEFRSsaf"
    assert conn.status == 200
    assert conn.resp_body == "914942744"
  end

  test "it returns the success status", %{conn: conn} do
    params =
    %{"entry" =>
    [
      %{"id" => "182374823439234", "messaging" =>
        [%{"message" =>
          %{"mid" => "mid.1232454687685:cfskah45kg3453gj", "seq" => 2, "text" => "Hello"},
          "recipient" => %{"id" => "18789686788657"},
          "sender" => %{"id" => "9887762354234"}, "timestamp" => 18926347868238}
        ],
      "time" => 19848937893}
    ], "object" => "page"}

    conn = post conn, "/webhook", params
    assert conn.status == 200
  end
end