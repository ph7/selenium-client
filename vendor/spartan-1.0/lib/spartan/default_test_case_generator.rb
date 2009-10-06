module Spartan

  module DefaultTestCaseGenerator

   def unit_tests(&block)
     Spartan::Internals.define_test_class(:suffix => "UnitTest", &block)
   end

   def functional_tests(&block)
     Spartan::Internals.define_test_class(:suffix => "FunctionalTest", &block)
   end

   def integration_tests(&block)
     Spartan::Internals.define_test_class(:suffix => "IntegrationTest", &block)
   end

  end
end