module Spartan

  module Rails23TestCaseGenerator

    def functional_tests(&block)
      Spartan::Internals.define_test_class(
        :suffix => "FunctionalTest", :base_class => ActiveSupport::TestCase,
        &block)
    end

  end

end