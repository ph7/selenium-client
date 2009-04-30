require File.expand_path(File.dirname(__FILE__) + '/../../unit_test_helper')

unit_tests do

  test "Example reporting_uid is the same when example is the same" do
    example_class = Class.new { include Spec::Example::ExampleMethods }
    example = example_class.new(:a_proxy) do puts "some implementation" end
    assert_equal example.reporting_uid, example.reporting_uid
  end

  test "Example reporting_uid are not equals when implementation is different" do
    example_class = Class.new { include Spec::Example::ExampleMethods }
    first_example = example_class.new(:a_proxy) do puts "some implementation" end
    second_example = example_class.new(:a_proxy) do puts "another implementation" end
    assert_not_equal first_example.reporting_uid, second_example.reporting_uid
  end

  test "ExampleProxy reporting_uid are equals when Example is the same" do
    example = stub_everything(:reporting_uid => 123)
    first_proxy = Spec::Example::ExampleProxy.new("first", :actual_example => example)
    second_proxy = Spec::Example::ExampleProxy.new("second", :actual_example => example)
    assert_equal first_proxy.reporting_uid, second_proxy.reporting_uid
  end

  test "ExampleProxy reporting_uid are different when Example is not the same" do
    first_proxy = Spec::Example::ExampleProxy.new("first", :actual_example => stub_everything(:reporting_uid => 123))
    second_proxy = Spec::Example::ExampleProxy.new("second", :actual_example => stub_everything(:reporting_uid => 456))
    assert_not_equal first_proxy.reporting_uid, second_proxy.reporting_uid
  end

  test "execution_error is exposed as an instance variable" do
    example_class = Class.new { include Spec::Example::ExampleMethods }
    example = example_class.new(:a_proxy) do puts "some implementation" end
    assert_nil example.execution_error
  end

end
