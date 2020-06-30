require 'typhoeus'
require 'date'
require 'nokogiri'
require './lib/lib'

class YahooDataPoint

  def initialize(row)
    columns = row.split(",")
    # @date = DateTime.strptime(columns[0], '%Y-%m-%d')
    @date = Time.parse(columns[0])
    @open = columns[1].to_f
    @high = columns[2].to_f
    @low = columns[3].to_f
    @close = columns[4].to_f
    @adjusted_close = columns[5].to_f
    @volume = columns[6].to_i
  end
  # Getters
  def date 
    @date
  end
  # Diff between high and low point
  def spread
    @high - @low
  end
  # Get % change
  def spread_ratio
    "#{((@high - @low) / @close * 100).round(2)}%"
  end
  def average_price
    (@high + @low) / 2
  end
  # Convert to string
  def to_s
    "Date: #{@date.strftime("%Y-%m-%d")} | Open: #{@open.round(2)} | High: #{@high.round(2)} | Low: #{@low.round(2)} | Close: #{@close.round(2)} | Adjusted Close: #{@adjusted_close.round(2)} | Volume: #{@volume} | Spread Ratio: #{spread_ratio}"
  end

end

class YahooApi

  def initialize(config)
    @config = config
  end

  def get_historic_stock_data(ticker, date_from, date_to, frequency = "1d")
    url = "https://query1.finance.yahoo.com/v7/finance/download/#{ticker}?period1=#{date_from.strftime("%s")}&period2=#{date_to.strftime("%s")}&interval=#{frequency}&events=history"

    request = Typhoeus::Request.new(url)
    request.run
    result = request.response.body

    result.split("\n").drop(1).map { |row| YahooDataPoint.new(row) }
  end

  def get_latest_price(ticker)
    url = "https://finance.yahoo.com/quote/#{ticker}"

    request = Typhoeus::Request.new(url)
    request.run
    result = request.response.body

    html_doc = Nokogiri::HTML(result)

    # This might have to be tweaked a bit
    html_doc.css('[data-test="BID-value"]').css('span').children.to_s.split("x").first.to_f
  end
end
