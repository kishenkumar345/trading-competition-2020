require 'typhoeus'
require 'json'
require './lib/lib'

# Class to wrap the European Central Bank API
class EcbApi

  def initialize(config)
    @config = config
  end

  # Call the ECB Exchange Rates API, all realtive to USD
  def get_exchange_rates(day, base = "USD")
    url = "https://api.exchangeratesapi.io/#{day.year}-#{day.month}-#{day.day}?base=#{base}"

    request = Typhoeus::Request.new(url)
    request.run
    result = request.response.body

    JSON.parse(result)
  end
end

# Get today's exchange rates, and some from last week as well
# day = Time.new( Time.now.year, Time.now.month, Time.now.day)
# puts get_exchange_rates(day)
# day -= 7.days
# puts get_exchange_rates(day)
