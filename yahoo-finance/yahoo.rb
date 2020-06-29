require 'typhoeus'
require 'date'

# Add time methods to Integer class, to allow us to subtract days
class Integer
  def day 
    86400 * self
  end

  def days
    86400 * self
  end
end

class YahooDataPoint

  def initialize(row)
    columns = row.split(",")
    @date = DateTime.strptime(columns[0], '%Y-%m-%d')
    @open = columns[1].to_f
    @high = columns[2].to_f
    @low = columns[3].to_f
    @close = columns[4].to_f
    @adjusted_close = columns[5].to_f
    @volume = columns[6].to_i
  end
  # Diff between high and low point
  def spread
    @high - @low
  end
  # Get % change
  def spread_ratio
    "#{((@high - @low) / @close * 100).round(2)}%"
  end
  # Convert to string
  def to_s
    "Date: #{@date.strftime("%Y-%m-%d")} | Open: #{@open.round(2)} | High: #{@high.round(2)} | Low: #{@low.round(2)} | Close: #{@close.round(2)} | Adjusted Close: #{@adjusted_close.round(2)} | Volume: #{@volume} | Spread Ratio: #{spread_ratio}"
  end

end

def get_stock_data(ticker, date_from, date_to, frequency = "1d")
  url = "https://query1.finance.yahoo.com/v7/finance/download/#{ticker}?period1=#{date_from.strftime("%s")}&period2=#{date_to.strftime("%s")}&interval=#{frequency}&events=history"

  request = Typhoeus::Request.new(url)
  request.run
  result = request.response.body

  result.split("\n").drop(1).map { |row| YahooDataPoint.new(row) }
end

# Note that you could get higher frequency, like split by minutes, or split by hours etc.
# Just gotta be careful with TimeZones, since US Exchanges are in different TimeZone so today in NZ, sometimes refers to previous day in US or other TimeZones
puts get_stock_data("AAPL", Time.now - 14.days, Time.now)