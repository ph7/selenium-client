module Spartan
  module TestCaseExtensions

    def test(description, &block)
      define_method spartan_context.valid_test_method_name_for(description) do
        instance_eval(&block)
      end
    end

    def describe(description, &block)
      spartan_context.descriptions_in_progress.push description
      yield
      spartan_context.descriptions_in_progress.pop
    end

    # Dedicated test definition context to avoid polluting TestCase's namespace
    def spartan_context
      @spartan_context ||= TestDefinitionContext.new(self)
    end

  end
end