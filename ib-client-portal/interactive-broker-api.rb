# accountId: U2686250
require 'typhoeus'
require 'json'
require './lib/lib'

class InteractiveBrokerApi

  BASE_URL = ""
  SSO_URL = ""

  def initialize(config)
    @config = config
    BASE_URL.replace "#{@config.get("APP_HOST")}/v1/portal"
    SSO_URL.replace "#{@config.get("APP_HOST")}/sso/Login?forwardTo=22&RL=1&ip2loc=US"
  end

  def call_api(method: "get", url:, data: nil)
    full_url = BASE_URL + url
    puts "# #{method}: #{full_url}".blue
    puts data.to_s.green if !data.nil?
    sleep(0.5)
    if data.nil?
      request = Typhoeus::Request.new(full_url, method: method, ssl_verifypeer: false, ssl_verifyhost: 0)
    else
      request = Typhoeus::Request.new(full_url, method: method, ssl_verifypeer: false, ssl_verifyhost: 0, body: data )
    end
    request.run
    response = request.response
    if !response.success?
      puts "\nTypeous Error: #{response.code.to_s} - #{response.return_message.to_s} - #{response.status_message.to_s}".red
      puts "#{response.body}\n".cyan
      return {}
    end
    result = response.body
    puts "\n#{result}\n".cyan
    return JSON.parse(result)
  end

  def ping_server
    puts "Pinging Server".green
    call_api(method: 'post', url: '/tickle')
  end

  def login
    puts "Logging in\n".green
    browser = HeadlessBrowser.new
    result = browser.login
    browser.close
    result
  end
  # In non-tiered account structures, returns a list of accounts for which the user can view position 
  # and account information. This endpoint must be called prior  to calling other /portfolio endpoints 
  # for those accounts. For querying a list of accounts  which the user can trade, see /iserver/accounts. 
  # For a list of subaccounts in tiered  account structures (e.g. financial advisor or ibroker accounts) 
  # see /portfolio/subaccounts.
  def portfolio_accounts
    data = call_api(method: "get", url: "/portfolio/accounts" )
    @accountId = data.first["accountId"]
    @accountId
  end

  def account_info
    data = call_api(method: "get", url: "/portfolio/#{@accountId}/meta" )
    data
  end

  def account_positions
    data = call_api(url: "/portfolio/#{@accountId}/positions" )
    data.each do |position|
      puts position.to_s 
    end
  end

  def sso_validate
    call_api(url: "/sso/validate" )
  end

  def auth_status
    call_api(method: "post", url: "/iserver/auth/status" )
  end

  def reauth
    call_api(method: "post", url: "/iserver/reauthenticate" )
  end

  def select_account(account_id)
    data = call_api(method: "post", url: "/iserver/account", data: {
      "acctId": account_id.to_s
    } )
  end

  def iserver_accounts
    call_api(url: "/iserver/accounts" )
  end

  def iserver_trades
    data = call_api(method: "get", url: "/iserver/account/trades" )
    data.each do |trade|
      puts trade.to_s 
    end
  end

  # Need to implement this still
  def buy(ticker, position)
    puts "Buying #{ticker}"
  end

  def sell(ticker, position)
    puts "Selling #{ticker}"
  end
  
end
