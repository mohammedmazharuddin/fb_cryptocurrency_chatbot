defmodule FbCryptocurrencyChatbot.Templates do
  @moduledoc """
  Module responsible for communicating back to facebook messenger
  """
  require Logger

  @doc """
  fetch button templates based on the button type

    * :type - type of button
    * :text - text to display with buttons
    * :buttons_list - list of buttons along with the payloads
    * :recipient - recipient to whome to send the message
  """
  @spec fetch_button_template(postback :: String.t, text :: String.t, buttons_list :: list, recipient :: String.t) :: {atom, term}
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

  def fetch_button_template(type, _text, _buttons_list, _recipient) do
    Logger.error("No template available for #{type}")
    {:error, %{}}
  end

  @doc """
  fetch button templates based on the button type

    * :type - type of button
    * :button_title - text to display with buttons
    * :items - list of items to be displayed
    * :recipient - recipient to whome to send the message
  """
  @spec fetch_single_button_generic_template(postback :: String.t, button_title :: String.t, items :: list, recipient :: String.t) :: {atom, term}
  def fetch_single_button_generic_template("postback", button_title, items, recipient) do
    elements =
      items
      |> Enum.map(
        &%{
          title: &1.name,
          image_url: &1.image,
          buttons: [
            %{
              type: "postback",
              title: button_title,
              payload: "GET_COIN_PRICE/#{&1.id}"
            }
          ]
        }
      )

    generic_template = %{
      recipient: %{
        id: recipient
      },
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "generic",
            elements: elements
          }
        }
      }
    }

    {:ok, generic_template}
  end

  def fetch_single_button_generic_template(type, _button_title, _items, _recipient) do
    Logger.error("No template available for #{type}")
    {:error, %{}}
  end
end
