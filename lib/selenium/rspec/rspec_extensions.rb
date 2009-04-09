require "rubygems"
gem "rspec", "=1.2.2"
require 'spec'
require 'spec/example/example_group'

#
# Monkey-patch RSpec Example Group so that we can track whether an
# example already failed or not in an after(:each) block
#
# useful to only capture Selenium screenshots when a test fails  
#
# Only changed execution_error to be an instance variable (in lieu of 
# a local variable).
#
module Spec
  module Example
    module ExampleMethods

      attr_reader :execution_error

      def execute(run_options, instance_variables) # :nodoc:
        puts caller unless caller(0)[1] =~ /example_group_methods/
        run_options.reporter.example_started(@_proxy)
        set_instance_variables_from_hash(instance_variables)
        
        execution_error = nil
        Timeout.timeout(run_options.timeout) do
          begin
            before_each_example
            instance_eval(&@_implementation)
          rescue Exception => e
            execution_error ||= e
          end
          begin
            after_each_example
          rescue Exception => e
            execution_error ||= e
          end
        end

        run_options.reporter.example_finished(@_proxy.update(description), execution_error)
        success = execution_error.nil? || ExamplePendingError === execution_error
      end
      
    end
  end
end

