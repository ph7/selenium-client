require 'rubygems'
require 'spec'
require 'base64'
require 'fileutils'
require File.expand_path(File.dirname(__FILE__) + "/../../../../lib/selenium")
<<<<<<< HEAD:test/integration/reporting/dummy_project/spec_helper.rb
require File.expand_path(File.dirname(__FILE__) + "/../../../../lib/selenium/rspec/spec_helper")
=======
require File.expand_path(File.dirname(__FILE__) + "/../../../../lib/selenium/rspec/rspec_extensions")
require File.expand_path(File.dirname(__FILE__) + "/../../../../lib/selenium/rspec/reporting/selenium_test_report_formatter")
>>>>>>> a0b6ef2b95b811fcc95500dca7746d78bbf8e85c:test/integration/reporting/dummy_project/spec_helper.rb

Spec::Runner.configure do |config|

<<<<<<< HEAD:test/integration/reporting/dummy_project/spec_helper.rb
=======
  config.before(:each) do
  end

>>>>>>> a0b6ef2b95b811fcc95500dca7746d78bbf8e85c:test/integration/reporting/dummy_project/spec_helper.rb
  config.after(:each) do    
<<<<<<< HEAD:test/integration/reporting/dummy_project/spec_helper.rb
    @selenium_driver.stop
=======
    begin 
      Selenium::RSpec::SeleniumTestReportFormatter.capture_system_state(@selenium_driver, self) if execution_error
      if @selenium_driver.session_started?
        selenium_driver.set_context "Ending example '#{self.description}'"
      end
    ensure
      @selenium_driver.stop
    end
>>>>>>> a0b6ef2b95b811fcc95500dca7746d78bbf8e85c:test/integration/reporting/dummy_project/spec_helper.rb
  end

  def create_selenium_driver(options = {})
    remote_control_server = options[:host] || ENV['SELENIUM_REMOTE_CONTROL'] || "localhost"
    port = options[:port] || ENV['SELENIUM_PORT'] || 4444
    browser = options[:browser] || ENV['SELENIUM_BROWSER'] || "*chrome"
    application_host = options[:application_host] || ENV['SELENIUM_APPLICATION_HOST'] || "localhost"
    application_port = options[:application_port] || ENV['SELENIUM_APPLICATION_PORT'] || "4444"
    timeout = options[:timeout] || 60
    @selenium_driver = Selenium::SeleniumDriver.new(remote_control_server, port, browser, "http://#{application_host}:#{application_port}", timeout)
  end

  def start_new_browser_session
    @selenium_driver.start_new_browser_session
    @selenium_driver.set_context "Starting example '#{self.description}'"
  end
  
  def selenium_driver
    @selenium_driver
  end
    
  def page
    @selenium_driver
  end
  
end

