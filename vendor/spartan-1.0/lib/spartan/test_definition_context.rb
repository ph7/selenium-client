module Spartan

  # Dedicated test definition context to avoid polluting TestCase's namespace
  class TestDefinitionContext
    attr_reader :test_definition_class

    def initialize(test_definition_class)
      @test_definition_class = test_definition_class
    end

    def descriptions_in_progress
      @descriptions_in_progress ||= []
    end

    def valid_test_method_name_for(test_description)
      test_name = test_method_name_for(test_description)
      if duplicated_test_method?(test_name)
        raise "'#{test_description}' is already defined in this test case (cut-and-paste?)"
      end
      test_name
    end

    def test_method_name_for(test_description)
      foo = [ "test", 
        descriptions_in_progress_method_component,
        normalize_description(test_description)
      ]
      foo.compact.join("_")
    end

    def descriptions_in_progress_method_component
      descriptions_in_progress.inject(nil) do |aggregated, desc|
        (aggregated || "") << "[#{normalize_description(desc)}]"
      end
    end
    
    def normalize_description(description)
      description.gsub(/[ \.,;:\(\)-]+/, "_")
    end

    def duplicated_test_method?(test_name)
      test_definition_class.instance_methods.include?(test_name) ||
      test_definition_class.instance_methods.include?(test_name.to_sym) # Ruby 1.9
    end
    
  end
end