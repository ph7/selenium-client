require File.expand_path(File.dirname(__FILE__) + '/../../unit_test_helper')

unit_tests do
  
  test "wait_for_text waits for the innerHTML content of an element when a locator is provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.expects(:wait_for_condition).with(regexp_matches(/findElement\('a_locator'\)/), anything)
    client.wait_for_text "some text", "a_locator"
  end

  test "wait_for_text waits for the page content when no locator is provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.expects(:wait_for_condition).with(regexp_matches(/find\('some text'\)/), anything)
    client.wait_for_text "some text"
  end

  test "wait_for_text uses default timeout when none is provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.expects(:wait_for_condition).with(anything, nil)
    client.wait_for_text "some text"
  end

  test "wait_for_text uses explicit timeout when provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.expects(:wait_for_condition).with(anything, :explicit_timeout)
    client.wait_for_text "some text", nil, :explicit_timeout
  end

  test "wait_for_no_text waits for the innerHTML content of an element when a locator is provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.expects(:wait_for_condition).with(regexp_matches(/findElement\('a_locator'\)/), anything)
    client.wait_for_no_text "some text", "a_locator"
  end

  test "wait_for_no_text waits for the page content when no locator is provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.expects(:wait_for_condition).with(regexp_matches(/find\('some text'\)/), anything)
    client.wait_for_no_text "some text"
  end

  test "wait_for_no_text uses default timeout when none is provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.expects(:wait_for_condition).with(anything, nil)
    client.wait_for_no_text "some text"
  end

  test "wait_for_no_text uses explicit timeout when provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.expects(:wait_for_condition).with(anything, :explicit_timeout)
    client.wait_for_no_text "some text", nil, :explicit_timeout
  end
  
  test "javascript_framework_for :prototype returns JavascriptFrameworks::Prototype" do
    client = Class.new { include Selenium::Client::Extensions }.new
    assert_equal Selenium::Client::JavascriptFrameworks::Prototype, 
                 client.javascript_framework_for(:prototype)
  end

  test "javascript_framework_for :jquery returns JavascriptFrameworks::JQuery" do
    client = Class.new { include Selenium::Client::Extensions }.new
    assert_equal Selenium::Client::JavascriptFrameworks::JQuery, 
                 client.javascript_framework_for(:jquery)
  end

  test "javascript_framework_for raises for unsupported framework" do
    client = Class.new { include Selenium::Client::Extensions }.new
    assert_raises(RuntimeError) { client.javascript_framework_for(:unsupported_framework) }
  end
  
  test "wait_for_ajax uses Ajax.activeRequestCount when default js framework is prototype" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.stubs(:default_javascript_framework).returns(:prototype)
    client.expects(:wait_for_condition).with("selenium.browserbot.getCurrentWindow().Ajax.activeRequestCount == 0", anything)
    client.wait_for_ajax
  end

  test "wait_for_ajax uses jQuery.active when default js framework is jQuery" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.stubs(:default_javascript_framework).returns(:jquery)
    client.expects(:wait_for_condition).with("selenium.browserbot.getCurrentWindow().jQuery.active == 0", anything)
    client.wait_for_ajax
  end

  test "wait_for_ajax can override default js framework" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.stubs(:default_javascript_framework).returns(:prototype)
    client.expects(:wait_for_condition).with("selenium.browserbot.getCurrentWindow().jQuery.active == 0", anything)
    client.wait_for_ajax :javascript_framework => :jquery    
  end
  
  test "wait_for_ajax uses default timeout when none is provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.stubs(:default_javascript_framework).returns(:prototype)
    client.expects(:wait_for_condition).with(anything, nil)
    client.wait_for_ajax
  end

  test "wait_for_ajax uses explicit timeout when provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.stubs(:default_javascript_framework).returns(:prototype)
    client.expects(:wait_for_condition).with(anything, :explicit_timeout)
    client.wait_for_ajax :timeout_in_seconds => :explicit_timeout
  end

  test "wait_for_effect uses Effect.Queue.size() when default js framework is prototype" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.stubs(:default_javascript_framework).returns(:prototype)
    client.expects(:wait_for_condition).with("selenium.browserbot.getCurrentWindow().Effect.Queue.size() == 0", anything)
    client.wait_for_effects
  end

  test "wait_for_effects uses default timeout when none is provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.stubs(:default_javascript_framework).returns(:prototype)
    client.expects(:wait_for_condition).with(anything, nil)
    client.wait_for_effects
  end
  
  test "wait_for_effects uses explicit timeout when provided" do
    client = Class.new { include Selenium::Client::Extensions }.new
    client.stubs(:default_javascript_framework).returns(:prototype)
    client.expects(:wait_for_condition).with(anything, :explicit_timeout)
    client.wait_for_effects :timeout_in_seconds => :explicit_timeout
  end

  test "quote_escaped returns a locator has is when its does not include any single quote" do
    client = Class.new { include Selenium::Client::Extensions }.new
    assert_equal "the_locator", client.quote_escaped("the_locator")
  end

  test "quote_escaped escape single quotes" do
    client = Class.new { include Selenium::Client::Extensions }.new
    assert_equal "//div[@id=\\'demo-effect-appear\\']", client.quote_escaped("//div[@id='demo-effect-appear']")
  end

end