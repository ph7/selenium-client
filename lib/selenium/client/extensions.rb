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

			# Wait for some text to be present (the wait is happening browser side).
			#
      # wait_for_text will search for the given argument within the innerHTML
      # of the current DOM. Note that this method treats a single string
      # as a special case.
      #
      # ==== Parameters
      # wait_for_text accepts an optional hash of parameters:
      # * <tt>:element</tt> - the DOM id of an element to limit the search
      # scope to, or a Selenium locator string.
      # * <tt>:timeout_in_seconds</tt> - the length of time to wait for
      # a match to appear
      # * <tt>:invert_result</tt> - when true, the match condition is inverted.
      # This is equivalent to calling wait_for_no_text.
      # 
      # ==== Regular Expressions
      # In addition to plain strings, wait_for_text accepts regular expressions
      # as the pattern specification. Note that the string is treated as a
      # quoted regular expression when no <tt>:element</tt> scope is specified.
      # 
      # ==== Examples
      # The following are equivalent, and will match "some text" anywhere
      # within the document:
      #   wait_for_text "some text"
      #   wait_for_text /some text/
      #
      # This will match "some text" anywhere within the specified element:
      #   wait_for_text /some text/, :element => "container"
      #
      # This will match "some text" only if it exactly matches the complete
      # innerHTML of the specified element: 
      #   wait_for_text "some text", :element => "container"
      #
      def wait_for_text(pattern, options={})
        script = find_text_script(pattern, options)
        wait_for_condition script, options[:timeout_in_seconds]
      end
      
      # Wait for some text to NOT be present (the wait in happenning browser side).
      #
      # See wait_for_text for usage details.
      def wait_for_no_text(pattern, options={})
        wait_for_text pattern, options.merge(:invert_result => true)  
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

      def find_text_script(pattern, options)
        if options[:element].nil? && !(pattern.kind_of? Regexp)
          pattern = Regexp.new(Regexp.quote(pattern))
        end          
        element = options[:element] || "document.body"
        
        match_script = if pattern.kind_of? Regexp
          "element != null && element.innerHTML.match(#{pattern.inspect})"
        else
          "element != null && element.innerHTML == '#{quote_escaped(pattern)}'"
        end
        match_script = "!(#{match_script})" if options[:invert_result]
        
        find_element_script element, match_script
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