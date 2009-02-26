module Selenium
  module Client

    # Convenience methods not explicitely part of the protocol
    module Extensions
	
	    # These for all Ajax request to finish (Only works if you are using prototype, the wait in happenning browser side)
	    #
	    # See http://davidvollbracht.com/2008/6/4/30-days-of-tech-day-3-waitforajax for
	    # more background.
      def wait_for_ajax(options={})
        framework = javascript_framework_for(options[:javascript_framework] || default_javascript_framework)
	      wait_for_condition "selenium.browserbot.getCurrentWindow().#{framework.ajax_request_tracker} == 0", 
	                         options[:timeout_in_seconds]
	    end
	
	    # Wait for all Prototype effects to be processed (the wait in happenning browser side).
	    #
	    # Credits to http://github.com/brynary/webrat/tree/master
			def wait_for_effects(options={})
			  wait_for_condition "selenium.browserbot.getCurrentWindow().Effect.Queue.size() == 0", 
			                     options[:timeout_in_seconds]
			end
			
			# Wait for an element to be present (the wait in happenning browser side).
		  def wait_for_element(locator, timeout_in_seconds=nil)
		    script = <<-EOS
		    var element;
		    try {
		      element = selenium.browserbot.findElement(#{js_string locator});
		    } catch(e) {
		      element = null;
		    }
		    element != null;
		    EOS

		    wait_for_condition script, timeout_in_seconds
		  end

			# Wait for an element to NOT be present (the wait in happenning browser side).
		  def wait_for_no_element(locator, timeout_in_seconds=nil)
		    script = <<-EOS
		    var element;
		    try {
		      element = selenium.browserbot.findElement(#{js_string locator});
		    } catch(e) {
		      element = null;
		    }
		    element == null;
		    EOS

		    wait_for_condition script, timeout_in_seconds
		  end

			# Wait for some text to be present (the wait in happenning browser side).
			#
			# If locator is nil or no locator is provided, the text will be
			# detected anywhere in the page.
			#
			# If a non nil locator is provided, the text will be
			# detected within the innerHTML of the element identified by the locator.			
		  def wait_for_text(text, locator=nil, timeout_in_seconds=nil)
		    script = case locator
		    when nil:
  		    <<-EOS
              var text;
              try {
                text = selenium.browserbot.getCurrentWindow().find(#{js_string text});
              } catch(e) {
                text = null;
              }
              text != null;
          EOS
        else
  		    <<-EOS
  		        var element;
                try {
                  element = selenium.browserbot.getCurrentWindow().findElement(#{js_string locator});
                } catch(e) {
                  element = null;
                }
                element != null && element.innerHTML == #{js_string text};
          EOS
        end          

		    wait_for_condition script, timeout_in_seconds
		  end

			# Wait for some text to NOT be present (the wait in happenning browser side).
			#
			# If locator is nil or no locator is provided, the text will be
			# detected anywhere in the page.
			#
			# If a non nil locator is provided, the text will be
			# detected within the innerHTML of the element identified by the locator.			
		  def wait_for_no_text(original_text, locator=nil, timeout_in_seconds=nil)
		    script = case locator
		    when nil:
		      <<-EOS
              var text;
              try {
                text = selenium.browserbot.getCurrentWindow().find(#{js_string original_text});
              } catch(e) {
                text = false;
              }
              text == false;
		      EOS
		    else
          <<-EOS
              var element;
              
              try {
                element = selenium.browserbot.findElement(#{js_string locator});
              } catch(e) {
                element = null;
              }
              alert(element);
              element != null && element.innerHTML != #{js_string original_text};
           EOS
		    end
        wait_for_condition script, timeout_in_seconds
		  end

			# Wait for a field to get a specific value (the wait in happenning browser side).
		  def wait_for_field_value(locator, expected_value, timeout_in_seconds=nil)
		    script = "var element;
		              try {
		                element = selenium.browserbot.findElement(#{js_string locator});
		              } catch(e) {
		                element = null;
		              }
		              element != null && element.value == #{js_string expected_value};"

		    wait_for_condition script, timeout_in_seconds
		  end

      def javascript_framework_for(framework_name)
        case framework_name.to_sym
        when :prototype
          JavascriptFrameworks::Prototype
        when :jquery
          JavascriptFrameworks::JQuery
        else
          raise "Unsupported Javascript Framework: '#{framework_name}'"
        end
      end


      private
      #-------------------------------------------------------------------------

      # Returns a new string for use inside javascript code, using single quotes
      def js_string(ruby_string)
        escaped_single_quotes = ruby_string.gsub("'", %q<\\\'>)
        return "'#{escaped_single_quotes}'"
      end

    end
  end
end