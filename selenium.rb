# Copyright 2004 ThoughtWorks, Inc
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
require 'net/http'
require 'uri'

# -----------------
# Original code by Aslak Hellesoy and Darren Hobbs
# -----------------

module Selenium

  class SeleneseInterpreter
    include Selenium
  
    def initialize(timeout)
      @timeout = timeout
    end
    
    def to_s
      "SeleneseInterpreter"
    end

    def do_command(commandString)
      timeout(@timeout) do
        http = Net::HTTP.new("localhost", "8080")
        response, result = http.get('/selenium-driver/driver?commandRequest=' + commandString)
        print "RESULT: " + result + "\n\n"
        if "|testComplete|||" == commandString
        	result = nil
        end
        if nil != result
          if "OK" != result
            if "PASSED" != result
              raise SeleniumCommandError, result
            end
          end
        end
        result
      end
    end
    
    alias old_type type
    def type(*args)
      method_missing("type", *args)
    end

    # Reserved ruby methods (such as 'send') must be prefixed with '__'
    def method_missing(method, *args)
      method_name = translate_method_to_wire_command(method)
      element_identifier = args[0]
      value = args[1]
      command_string = "|#{method_name}|#{element_identifier}|#{value}|"
      do_command(command_string)
    end
  end

  def translate_method_to_wire_command (method)
      method_no_prefix = (method.to_s =~ /__(.*)/ ? $1 : method.to_s)
      dropped_underscores = (method_no_prefix.gsub(/(_(.))/) {$2.upcase}) 
  end
  private :translate_method_to_wire_command
  
end

class SeleniumCommandError < RuntimeError 
end
