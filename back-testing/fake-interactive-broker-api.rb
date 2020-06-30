
# This API will be responsible for managing the fake amounts of money required for the back-testing
class FakeInteractiveBrokerApi

  def initialize(config)
    @config = config
    @starting_balance = 1000000
    @account_balance = @starting_balance
    @positions = {}
  end

  def ping_server
    puts "Pinging Server".green
  end

  def login
    puts "Logging in\n".green
  end

  # Fake buy and sell methods
  def buy(ticker, position, price)
    if @account_balance < position * price 
      puts "Cannot buy #{position}@#{price} of #{ticker} as we only have #{@account_balance} available".red 
      return
    end
    puts "Buying #{position}@#{price} of #{ticker}".green
    @account_balance -= position * price 
    @positions[ticker] = 0 if @positions[ticker].nil?
    @positions[ticker] += position
  end

  def sell(ticker, position, price)
    # Block us selling stocks we do not have
    if @positions[ticker].nil? || position > @positions[ticker]
      puts "Cannot sell #{position}@#{price} of #{ticker} as we only have #{@positions[ticker]} available".red 
      return
    end
    # 'Execute' the trade
    puts "Selling #{position}@#{price} of #{ticker}".green
    @account_balance += position * price 
    @positions[ticker] -= position
  end
  
  # Get the account balance
  def account_balance
    @account_balance
  end
  # Get the portfolio value
  def portfolio_value(fake_yahoo_api)
    # Go through our positions and add them up, then add in the cash balance
    @positions.map { |key, value| fake_yahoo_api.get_latest_price(key) * @positions[key] || 0 }
      .reduce(:+) || 0
      + account_balance
  end
  # PnL gain / loss
  def pnl(fake_yahoo_api)
    "#{((portfolio_value(fake_yahoo_api) - @starting_balance) / @starting_balance * 100).round(2)}%"
  end

end