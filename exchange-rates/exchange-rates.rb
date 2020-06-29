require 'typhoeus'
require 'json'

# Add time methods to Integer class, to allow us to subtract days
class Integer
  def day 
    86400 * self
  end

  def days
    86400 * self
  end
end 

# Call the ECB Exchange Rates API, all realtive to USD
def get_exchange_rates(day, base = "USD")
  url = "https://api.exchangeratesapi.io/#{day.year}-#{day.month}-#{day.day}?base=#{base}"

  request = Typhoeus::Request.new(url)
  request.run
  result = request.response.body

  JSON.parse(result)
end

# Get today's exchange rates, and some from last week as well
day = Time.new( Time.now.year, Time.now.month, Time.now.day)
puts get_exchange_rates(day)
day -= 7.days
puts get_exchange_rates(day)
