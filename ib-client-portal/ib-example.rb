require './interactive_broker.rb'

# Wraps the Interactive Broker API
api = InteractiveBrokerApi.new

# Global variable to keep track if bot is running or not
$keep_running = true
def program_running?
  $keep_running
end

# Start the server
puts "Spawning IB Client Portal".green
pid = Process.spawn("bin/run.sh root/conf.yml")
puts "\n\n"
# Attemp to Login with Capybara
sleep(5)
if ! api.login
  puts "Error logging in".red
  Process.kill :QUIT, pid
  exit
end

# Some random API calls we can make
api.sso_validate
api.auth_status
api.reauth
api.auth_status
# Must call this before we can query trades
account_id = api.portfolio_accounts 
api.select_account(account_id)
api.account_info
api.account_positions

# Stay logged in with tickle in the main loop
while program_running?
  api.iserver_accounts
  api.iserver_trades

  # Tickle the server every 15 seconds to keep the connection open
  sleep(15)
  api.ping_server
  # Now quit so we can clean up Java process
  $keep_running = false
end

# Clean up Java server, bit awkward to do this
puts "Killing server".green
begin
  Process.kill :QUIT, pid
rescue
  puts "Did not execute".red
end
# Wait just in case it did not quit, then ctrl+c will go to child process
puts "Press Ctrl+C to exit".black.bg_green
_, status = Process.wait2 pid