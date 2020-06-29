


class NasdaqBot

  def initialize(config, ib_api, yahoo_api)
    @config = config
    @ib_api = ib_api
    @yahoo_api = yahoo_api
  end

  # Each bot could have a trade method where the logic goes
  def trade
    price = @yahoo_api.get_latest_price("AAPL")
    # Buy if cheap enough
    if price < 0.2
      @ib_api.buy("AAPL", 100)
    end
    # Sell if expensive enough
    if price > 0.4 
      @ib_api.sell("AAPL", 100)
    end
  end
end
