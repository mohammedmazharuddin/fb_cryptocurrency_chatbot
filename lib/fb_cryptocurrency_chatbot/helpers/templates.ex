defmodule FbCryptocurrencyChatbot.Templates do
  @moduledoc """
  Module responsible for communicating back to facebook messenger
  """
  require Logger
  alias FbCryptocurrencyChatbot.HttpUtility

  @doc """
  fetch button templates based on the button type

    * :type - type of button
    * :text - text to display with buttons
    * :buttons_list - list of buttons along with the payloads
  """
  def fetch_button_template("postback", text, buttons_list, recipient) do
    buttons =
      buttons_list
      |> Enum.map(
        &%{
          type: "postback",
          title: elem(&1, 0),
          payload: elem(&1, 1)
        }
      )

    buttons_template = %{
      recipient: %{
        id: recipient
      },
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "button",
            text: text,
            buttons: buttons
          }
        }
      }
    }
    {:ok, buttons_template}
  end

  def fetch_button_template(type, _text, _buttons_list) do 
    Logger.error("No template available for #{type}")
    {:error, %{}}
  end
end
