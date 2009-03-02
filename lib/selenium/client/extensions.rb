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
	      wait_for_condition window_script("#{framework.ajax_request_tracker} == 0"),
	                         options[:timeout_in_seconds]
	    end

	    # Wait for all Prototype effects to be processed (the wait in happenning browser side).
	    #
	    # Credits to http://github.com/brynary/webrat/tree/master
			def wait_for_effects(options={})
			  wait_for_condition window_script("Effect.Queue.size() == 0"),
			                     options[:timeout_in_seconds]
			end

			# Wait for an element to be present (the wait in happenning browser side).
		  def wait_for_element(locator, options={})
		    wait_for_condition find_element_script(locator, "element != null"),
		                       options[:timeout_in_seconds]
		  end

			# Wait for an element to NOT be present (the wait in happenning browser side).
		  def wait_for_no_element(locator, options={})
		    wait_for_condition find_element_script(locator, "element == null"),
		                       options[:timeout_in_seconds]
		  end

			# Wait for some text to be present (the wait in happenning browser side).
			#
			# If locator is nil or no locator is provided, the text will be
			# detected anywhere in the page.
			#
			# If a non nil locator is provided, the text will be
			# detected within the innerHTML of the element identified by the locator.
		  def wait_for_text(text, options={})
        script = options[:element].nil? ?
                 find_text_script(text, "text != null && text != false") :
                 find_element_script(options[:element],
                    "element != null && element.innerHTML == '#{quote_escaped(text)}'")

		    wait_for_condition script, options[:timeout_in_seconds]
		  end

			# Wait for some text to NOT be present (the wait in happenning browser side).
			#
			# If locator is nil or no locator is provided, the text will be
			# detected anywhere in the page.
			#
			# If a non nil locator is provided, the text will be
			# detected within the innerHTML of the element identified by the locator.
		  def wait_for_no_text(original_text, options={})
        script = options[:element].nil? ?
                 find_text_script(original_text, "(text == false || text == null)") :
                 find_element_script(options[:element],
                    "(element == null || element.innerHTML != '#{quote_escaped(original_text)}')")
        wait_for_condition script, options[:timeout_in_seconds]
		  end

			# Wait for a field to get a specific value (the wait in happenning browser side).
      def wait_for_field_value(locator, expected_value, options={})
        script = find_element_script(locator,
            "(element != null && element.value == '#{quote_escaped(expected_value)}')")
        wait_for_condition script, options[:timeout_in_seconds]
      end

      def wait_for_no_field_value(locator, expected_value, options={})
        script = find_element_script(locator,
            "(element == null || element.value != '#{quote_escaped(expected_value)}')")
        wait_for_condition script, options[:timeout_in_seconds]
      end

      def javascript_framework_for(framework_name)
        case framework_name.to_sym
        when :prototype
          JavascriptFrameworks::Prototype
        when :jquery
          JavascriptFrameworks::JQuery
        else
          raise "Unsupported Javascript Framework: #{framework_name}"
        end
      end

      def find_element_script(locator, return_value)
        script = <<-EOS
          var element;

          try {
            element = selenium.browserbot.findElement('#{quote_escaped(locator)}');
          } catch(e) {
            element = null;
          }
          #{return_value};
        EOS
      end

      def find_text_script(text, return_value)
        script = <<-EOS
          var text;

          try {
            text = selenium.browserbot.getCurrentWindow().find('#{quote_escaped(text)}');
          } catch(e) {
            text = null;
          }
          #{return_value};
        EOS
      end

      def window_script(expression)
        "selenium.browserbot.getCurrentWindow().#{expression};"
      end

      def quote_escaped(a_string)
        a_string.gsub(/'/, %q<\\\'>)
      end

    end
  end
end