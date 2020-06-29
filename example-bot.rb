require './yahoo-finance/yahoo-api'
require './ib-client-portal/interactive-broker-api'
require './ib-client-portal/interactive-broker-client'
require './exchange-rates/exchange-rates-api'
require './bots/lse-bot'
require './bots/nasdaq-bot'
require './config'

config = Config.build("./.env")

ib_client = InteractiveBrokerClient.new(config)
ib_api = InteractiveBrokerApi.new(config)
yahoo_api = YahooApi.new(config)
ecb_api = EcbApi.new(config)

ib_client.start
puts "Error Logging in " if !ib_client.login

# Dependency Inject the bot to be used based on config file
bot = LseBot.new(config, ib_api, yahoo_api) if config.get("BOT") == "LSE"
bot = NasdaqBot.new(config, ib_api, yahoo_api) if config.get("BOT") == "NASDAQ"

# Run the bot in a separate thread
running = true
Thread.new do
  while running
    # The main logic of the bot should go here.  You could extract this out to a separate class, like "bot.rb", or make multiple bots and use dependency injection to select which to use
    bot.trade
    # Tickle the server every 15 seconds to keep the connection open
    sleep(15)
    ib_api.ping_server
  end
end

command = "pending"
while command != "quit"
  puts "Type quit to end"
  command = gets.chomp
  running = false if command == "quit"
end

ib_client.stop