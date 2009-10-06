require File.expand_path(File.dirname(__FILE__) + '/spartan/internals')
require File.expand_path(File.dirname(__FILE__) + '/spartan/test_definition_context')
require File.expand_path(File.dirname(__FILE__) + '/spartan/test_case_extensions')
require File.expand_path(File.dirname(__FILE__) + '/spartan/default_test_case_generator')
require File.expand_path(File.dirname(__FILE__) + '/spartan/rails23_test_case_generator')
require "test/unit"

Object.send :include, Spartan::DefaultTestCaseGenerator
Test::Unit::TestCase.send :extend, Spartan::TestCaseExtensions
