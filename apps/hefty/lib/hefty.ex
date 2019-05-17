defmodule Hefty do
  @moduledoc """
  Documentation for Hefty.

  Hefty comes from hftb
  (high frequence trading backend)
  """

  import Ecto.Query, only: [from: 2]
  require Logger

  def fetch_stream_settings() do
    query =
      from(ss in Hefty.Repo.StreamingSetting,
        order_by: ss.symbol
      )

    Hefty.Repo.all(query)
  end

  def fetch_tick(symbol) do
    case from(te in Hefty.Repo.Binance.TradeEvent,
      order_by: [desc: te.trade_time],
      where: te.symbol == ^symbol,
      limit: 1
    )
      |> Hefty.Repo.one do
      nil    -> %{:symbol => symbol, :price => "N/A"}
      result -> result
    end
  end

  def fetch_streaming_symbols() do
    Hefty.Streaming.Server.fetch_streaming_symbols()
  end

  def flip_streamer(symbol) do
    Hefty.Streaming.Server.flip_stream(symbol)
  end

  def flip_trader(symbol) do
    # Hefty.Trading.Server.flip_trading(symbol)
    {:ok, symbol}
  end
end
