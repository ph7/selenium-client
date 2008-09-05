require 'rubygems'
require 'spec'
<<<<<<< HEAD:test/integration/spec_helper.rb
=======
require 'base64'
require 'fileutils'
>>>>>>> a0b6ef2b95b811fcc95500dca7746d78bbf8e85c:test/integration/spec_helper.rb
require File.expand_path(File.dirname(__FILE__) + "/../../lib/selenium")
<<<<<<< HEAD:test/integration/spec_helper.rb
require File.expand_path(File.dirname(__FILE__) + "/../../lib/selenium/rspec/spec_helper")
=======
require File.expand_path(File.dirname(__FILE__) + "/../../lib/selenium/rspec/rspec_extensions")
require File.expand_path(File.dirname(__FILE__) + "/../../lib/selenium/rspec/reporting/selenium_test_report_formatter")
>>>>>>> a0b6ef2b95b811fcc95500dca7746d78bbf8e85c:test/integration/spec_helper.rb

Spec::Runner.configure do |config|

  config.before(:each) do
    create_selenium_driver
  end

  config.after(:each) do
<<<<<<< HEAD:test/integration/spec_helper.rb
    selenium_driver.stop
=======
    begin 
      Selenium::RSpec::SeleniumTestReportFormatter.capture_system_state(@selenium_driver, self) if execution_error
      if @selenium_driver.session_started?
        selenium_driver.set_context "Ending example '#{self.description}'"
      end
    ensure
      @selenium_driver.stop
    end
  end

  def start_new_browser_session
    @selenium_driver.start_new_browser_session
    @selenium_driver.set_context "Starting example '#{self.description}'"
>>>>>>> a0b6ef2b95b811fcc95500dca7746d78bbf8e85c:test/integration/spec_helper.rb
  end

  def selenium_driver
    @selenium_driver
  end
    
  def page
    @selenium_driver
  end

<<<<<<< HEAD:test/integration/spec_helper.rb
=======
  config.after(:each) do    
  end

>>>>>>> a0b6ef2b95b811fcc95500dca7746d78bbf8e85c:test/integration/spec_helper.rb
  def create_selenium_driver
    remote_control_server = ENV['SELENIUM_RC_HOST'] || "localhost"
    port = ENV['SELENIUM_RC_PORT'] || 4444
    browser = ENV['SELENIUM_RC_BROWSER'] || "*firefox"
    timeout = ENV['SELENIUM_RC_TIMEOUT'] || 60
    application_host = ENV['SELENIUM_APPLICATION_HOST'] || "localhost"
    application_port = ENV['SELENIUM_APPLICATION_PORT'] || "3000"
    @selenium_driver = Selenium::SeleniumDriver.new(
        remote_control_server, port, browser, 
        "http://#{application_host}:#{application_port}", timeout)
  end
<<<<<<< HEAD:test/integration/spec_helper.rb
  
  def start_new_browser_session
    selenium_driver.start_new_browser_session
    selenium_driver.set_context "Starting example '#{self.description}'"
  end
=======
>>>>>>> a0b6ef2b95b811fcc95500dca7746d78bbf8e85c:test/integration/spec_helper.rb

<<<<<<< HEAD:test/integration/spec_helper.rb
=======
  
  
>>>>>>> a0b6ef2b95b811fcc95500dca7746d78bbf8e85c:test/integration/spec_helper.rb
end

