require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'


# Wrapper to manage Chrome
class HeadlessBrowser 
  include Capybara::DSL

  def initialize(config)
    # Setup Capybara browser
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
    # For some reason headless does not work
    Capybara.register_driver :headless_selenium do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: {
          args: %w[headless enable-features=NetworkService,NetworkServiceInProcess]
        }
      )
      Capybara::Selenium::Driver.new app,
        browser: :chrome,
        options: options,
        desired_capabilities: capabilities
    end
    # Configure capybara
    Capybara.configure do |c|
      c.run_server = false
      c.default_driver = :selenium
      c.app_host = config.get("APP_HOST")
    end
    @config = config
    @short_wait = 0.5
    @medium_wait = 5
    @long_wait = 10
  end

  ##Waiting
  def wait_for_a_little
    sleep @short_wait
  end
  def wait_a_second
    sleep 1
  end
  def wait_a_while
    sleep @medium_wait
  end
  def wait_ages
    sleep @long_wait
  end
  # Login to IB Portal
  def login(username, password)
    visit ('/')
    wait_a_second
    begin
      fill_in :placeholder => "Username", :with => username
      fill_in :placeholder => "Password", :with => password
      click_button("Login")
    rescue
      return false
    end
    wait_a_second
    return true if page.body.include? "Client login succeeds"
    false
  end
  # Close the Browser
  def close_window
    page.driver.browser.close
  end
  # Kill the process, for some reason this does not work yet
  def kill 
    page.quit
    page.driver.quit
  end
end

# Wrapper for the Java API Client
class InteractiveBrokerClient

  def initialize(config)
    @config = config
    @pid = 0
    @browser = HeadlessBrowser.new(config)
  end

  # Start the server
  def start 
    puts "Spawning IB Client Portal".green
    if Dir.pwd.split("/").last == "ib-client-portal"
      @pid = Process.spawn("bin/run.sh root/conf.yml")
    else 
      @pid = Process.spawn("cd ib-client-portal && bin/run.sh root/conf.yml")
    end
  end
  # Login automatically
  def login
    @browser.login(@config.get("IB_USERNAME"), @config.get("IB_PASSWORD"))
    @browser.close_window
  end
  # Clean up Java server, bit awkward to do this
  def stop
    puts "Killing Capybara".green
    @browser.kill
    puts "Killing IB Client Portal".green
    begin
      Process.kill :QUIT, @pid
    rescue
      puts "Did not execute".red
    end
    # Wait just in case it did not quit, then ctrl+c will go to child process
    puts "Press Ctrl+C to exit".black.bg_green
    _, status = Process.wait2 @pid
  end

end



