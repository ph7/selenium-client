require File.expand_path(__FILE__ + '/../../spec_helper')

describe "Wait For (No) Field Value" do

  it "wait_for_field_value blocks until field is updated" do
    page.open "http://localhost:4567/prototype.html"
    page.text("calculator-result").should be_empty
    page.type "calculator-expression", "2 + 2"
    page.click "calculator-button", :wait_for => :value,
                                    :element => "calculator-result",
                                    :value => "4"
    page.value("calculator-result").should eql("4")
  end
  
  it "wait_for_no_field_value blocks until field is updated" do
    page.open "http://localhost:4567/prototype.html"
    page.text("calculator-result").should be_empty
    page.type "calculator-expression", "2 + 2"
    page.click "calculator-button", :wait_for => :no_value,
                                    :element => "calculator-result",
                                    :value => ""
    page.value("calculator-result").should eql("4")
  end
  
  it "wait_for_field_value times out when field is never properly updated" do
    page.open "http://localhost:4567/prototype.html"
    page.text("calculator-result").should be_empty
    page.type "calculator-expression", "2 + 2"
    should_timeout do
      page.click "calculator-button", :wait_for => :value,
                                      :element => "calculator-result",
                                      :value => "5",
                                       :timeout_in_seconds => 2
    end
  end

  it "wait_for_no_field_value times out when field is never properly updated" do
    page.open "http://localhost:4567/prototype.html"
    should_timeout do
      page.wait_for_no_field_value "calculator-result", "", :timeout_in_seconds => 2
    end
  end
  
end
