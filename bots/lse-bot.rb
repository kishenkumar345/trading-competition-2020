

class LseBot

  def initialize(config, ib_api, yahoo_api)
    @config = config
    @ib_api = ib_api
    @yahoo_api = yahoo_api
    @target_tickers = []
    @target_prices = {}
    @config.get("BOT_TARGET_TICKERS").split(",").each do |input_string|
      ticker = input_string.split("::").first 
      @target_tickers << ticker
      @target_prices[ticker] = {
        min_price: input_string.split("::").last.split("-").first.to_f,
        max_price: input_string.split("::").last.split("-").last.to_f,
      }
    end
  end

  # Each bot could have a trade method where the logic goes
  def trade
    @target_tickers.each do |ticker|
      price = @yahoo_api.get_latest_price(ticker)
      # Buy if cheap enough
      if price < @target_prices[ticker][:min_price]
        @ib_api.buy(ticker, 100, price)
      end
      # Sell if expensive enough
      if price > @target_prices[ticker][:max_price]
        @ib_api.sell(ticker, 100, price)
      end
    end
  end

end