defmodule FbCryptocurrencyChatbot.CoinGeckoService do
  @moduledoc """
  Provides services methods for fetching data from Coingecko API server
  """
  alias FbCryptocurrencyChatbot.HttpUtility
  require Logger

  def fetch_coins() do
    query = "order=market_cap_desc&per_page=5&localization=false&market_data=false"
    url = "https://api.coingecko.com/api/v3/coins?#{query}"

    with {:ok, resp} <- HttpUtility.request(:get, url, "", []) do
      coins =
        resp.body
        |> Poison.decode!()
        |> Enum.map(&%{name: &1["name"], id: &1["id"], image: &1["image"]["large"]})

      {:ok, coins}
    end
  end
end
