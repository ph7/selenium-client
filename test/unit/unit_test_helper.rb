$: << File.expand_path(File.dirname(__FILE__) + "/../../vendor/mocha-0.9.5/lib")
require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require File.expand_path(File.dirname(__FILE__) + "/../../vendor/mocha-0.9.5/lib/mocha")
require File.expand_path(File.dirname(__FILE__) + "/../../vendor/spartan-1.0/lib/spartan")
require File.expand_path(File.dirname(__FILE__) + "/../../lib/selenium")
require File.expand_path(File.dirname(__FILE__) + "/../../lib/selenium/rspec/reporting/file_path_strategy")
require File.expand_path(File.dirname(__FILE__) + "/../../lib/selenium/rspec/reporting/system_capture")
require File.expand_path(File.dirname(__FILE__) + "/../../lib/selenium/rspec/rspec_extensions")

Test::Unit::TestCase.class_eval do
  
  def assert_true(result)
    assert_equal true, result
  end

  def assert_false(result)
    assert_equal false, result
  end
  
  def assert_stderr_match(expected, &block)
    original_stderr = Object.send :remove_const, :STDERR
    Object.const_set :STDERR, StringIO.new
    yield
    STDERR.rewind
    assert_match expected, STDERR.read    
  ensure
    Object.send :remove_const, :STDERR
    Object.const_set :STDERR, original_stderr
  end

end
  