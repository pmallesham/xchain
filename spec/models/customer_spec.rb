require File.dirname(__FILE__) + '/../spec_helper'

describe Customer do
  before(:each) do
    @customer = Customer.find(1)
  end

  it "should be valid" do
    @customer.should be_valid
  end
  
  it "should have agents" do 
  	@customer.should have(1).agents 
  end
  	
end
