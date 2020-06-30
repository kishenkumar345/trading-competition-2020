require './lib/lib'
require './yahoo-finance/yahoo-api.rb'

# What we can do is change the time on this Fake API and have it serve up prices based on that time
class FakeYahooApi

  def initialize(config)
    @config = config
    @fake_time = Time.now
  end
  
  def set_time(new_time)
    @fake_time = new_time 
  end
  def add_time(extra_time)
    @fake_time += extra_time 
  end

  # Get historic data up to current fake time
  def get_historic_stock_data(ticker, date_from, date_to, frequency = "1d")
    url = "https://query1.finance.yahoo.com/v7/finance/download/#{ticker}?period1=#{date_from.strftime("%s")}&period2=#{date_to.strftime("%s")}&interval=#{frequency}&events=history"

    request = Typhoeus::Request.new(url)
    request.run
    result = request.response.body

    result.split("\n").drop(1).map { |row| YahooDataPoint.new(row) }
  end
  # Go to historic data, and pick out closest match
  def get_latest_price(ticker)
    result = get_historic_stock_data(ticker, @fake_time - 2.days, @fake_time + 2.days, "1d")
    price_result = 0
    result.each { |point| 
      # Since markets are closed on weekends and holidays, we must take the latest day the market was open
      if point.date < @fake_time 
        price_result = point.average_price
      end
    }
    price_result
  end
  
end

