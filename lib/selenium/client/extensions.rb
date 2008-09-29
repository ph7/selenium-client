module Selenium
  module Client

    # Convenience methods not explicitely part of the protocol
    module Extensions
	
	    # These for all Ajax request to finish (Only works if you are using prototype)
	    #
	    # See http://davidvollbracht.com/2008/6/4/30-days-of-tech-day-3-waitforajax for
	    # more background.
      def wait_for_ajax(timeout=nil)
	      selenium.wait_for_condition "selenium.browserbot.getCurrentWindow().Ajax.activeRequestCount == 0", 
	                                  timeout || default_timeout_in_seconds
	    end
	
	    # Wait for all Prototype effects to be processed 
	    #
	    # Credits to http://github.com/brynary/webrat/tree/master
			def wait_for_effects(timeout=nil)
			  selenium.wait_for_condition "window.Effect.Queue.size() == 0", timeout || default_timeout_in_seconds
			end
			
		  def wait_for_element(field_name, time=60000)
		    script = <<-EOS
		    var element;
		    try {
		      element = selenium.browserbot.findElement('#{field_name}');
		    } catch(e) {
		      element = null;
		    }
		    element != null
		    EOS

		    wait_for_condition script, time
		  end

		  def wait_for_text(field_name, text, time=60000)
		    script = "var element;
		              try {
		                element = selenium.browserbot.findElement('#{field_name}');
		              } catch(e) {
		                element = null;
		              }
		              element != null && element.innerHTML == '#{text}'"

		    wait_for_condition script, time
		  end

		  def wait_for_text_change(field_name, original_text, time=60000)
		    script = "var element;
		              try {
		                element = selenium.browserbot.findElement('#{field_name}');
		              } catch(e) {
		                element = null;
		              }
		              element != null && element.innerHTML != '#{original_text}'"

		    wait_for_condition script, time
		  end

		  def wait_for_field_value(field_name, value, time=60000)
		    script = "var element;
		              try {
		                element = selenium.browserbot.findElement('#{field_name}');
		              } catch(e) {
		                element = null;
		              }
		              element != null && element.value == '#{value}'"

		    wait_for_condition script, time
		  end

    end
  end
end