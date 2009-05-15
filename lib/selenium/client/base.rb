module Selenium
  module Client
    
		# Driver constructor and session management commands
    module Base
      include Selenium::Client::Protocol
      include Selenium::Client::GeneratedDriver
      include Selenium::Client::Extensions
      include Selenium::Client::Idiomatic

      attr_reader :host, :port, :browser_string, :browser_url, 
                  :default_timeout_in_seconds, :default_javascript_framework,
                  :auto_highlighting
  
      #
      # Create a new client driver
      #
      # ==== Example:
      #
      #   Selenium::Client::Driver.new \ 
      #     :host => "localhost",
      #     :port => 4444,
      #     :browser => "*firefox",
      #     :timeout_in_seconds => 10,
      #     :url => "http://localhost:3000",
      #
      # ==== Options:
      #
      # [<tt>:javascript_framework</tt>]
      #     set the default javascript framework used for <tt>:wait_for</tt>
      #     AJAX and effects semantics (<tt>:prototype</tt> is the default value)
      #
      # [<tt>:auto_highlighting</tt>]
      #     turns on automatic highlighting of elements
      #     (default value: <tt>false</tt>)
      #
      # ==== Example:
      #
      #   Selenium::Client::Driver.new \ 
      #     :host => "localhost",
      #     :port => 4444,
      #     :browser => "*firefox",
      #     :timeout_in_seconds => 10,
      #     :url => "http://localhost:3000",
      #     :javascript_framework => :jquery,
      #     :auto_highlighting => true,
      #
      def initialize(*args)
        if args[0].kind_of?(Hash)
          options = args[0]
          @host = options[:host]
          @port = options[:port].to_i
          @browser_string = options[:browser]
          @browser_url = options[:url]
          @default_timeout_in_seconds = (options[:timeout_in_seconds] || 300).to_i
          @default_javascript_framework = options[:javascript_framework] || :prototype
          @auto_highlighting = options[:auto_highlighting] || false
        else
          @host = args[0]
          @port = args[1].to_i
          @browser_string = args[2]
          @browser_url = args[3]
          @default_timeout_in_seconds = (args[4] || 300).to_i
          @default_javascript_framework = :prototype
          @auto_highlighting = false
        end

        @extension_js = ""
        @session_id = nil
      end

      def session_started?
        not @session_id.nil?
      end

      # Starts a new browser session (launching a new browser matching 
      # configuration provided at driver creation time).
      #
      # Browser session specific option can also be provided. e.g.
      #
      #    driver.start_new_browser_session(:captureNetworkTraffic => true)
      #
      def start_new_browser_session(options={})
        options_as_string = options.collect {|key,value| "#{key.to_s}=#{value.to_s}"}.sort.join(";")
        result = string_command "getNewBrowserSession", [@browser_string, @browser_url, @extension_js, options_as_string]
        @session_id = result
        # Consistent timeout on the remote control and driver side.
        # Intuitive and this is what you want 90% of the time
        self.remote_control_timeout_in_seconds = @default_timeout_in_seconds 
      end
      
      def close_current_browser_session
        remote_control_command "testComplete" if @session_id
        @session_id = nil
      end
      
      def start
        start_new_browser_session
      end
      
      def stop
	      close_current_browser_session
      end
            
      def chrome_backend?
        ["*chrome", "*firefox", "*firefox2", "*firefox3"].include?(@browser_string)
      end

      def javascript_extension=(new_javascript_extension)
        @extension_js = new_javascript_extension
	    end
	
      def set_extension_js(new_javascript_extension)
	      javascript_extension = new_javascript_extension
      end
      
    end
  
  end
end
