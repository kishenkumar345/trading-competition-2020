require './back-testing/fake-yahoo-api'
require './back-testing/fake-interactive-broker-api'
require './bots/lse-bot'
require './bots/nasdaq-bot'
require './config'
require 'time'
# You could set it up to have an entirely different set of parameters for testing
config = Config.build("./test.env")

ib_api = FakeInteractiveBrokerApi.new(config)
yahoo_api = FakeYahooApi.new(config)

bot = LseBot.new(config, ib_api, yahoo_api)

yahoo_api.set_time(Time.parse(config.get("BOT_START_DATE")))

config.get("BOT_DAYS_TO_TEST").to_i.times do |n|
  bot.trade
  yahoo_api.add_time(1.day)
end

puts "Fund performance was #{ib_api.pnl(yahoo_api)}"