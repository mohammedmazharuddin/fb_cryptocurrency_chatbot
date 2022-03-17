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

  def fetch_coin_price(coin_id) do
    query = "vs_currency=usd&days=14"
    url = "https://api.coingecko.com/api/v3/coins/#{coin_id}/market_chart?#{query}"

    with {:ok, resp} <- HttpUtility.request(:get, url, "", []) do
      prices =
        resp.body
        |> Poison.decode!()
        |> Map.fetch!("prices")
        |> Enum.map(& Float.round(Enum.at(&1, 1), 2))

      prices_list = 
        prices 
        |> Enum.chunk_every(100)
        |> Enum.map(
          & Enum.reduce(&1, "", fn price, acc -> acc <> "#{to_string(price)} USD \n" end)
        )
      {:ok, prices_list}
    end
  end
end
