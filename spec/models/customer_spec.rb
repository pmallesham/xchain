require File.dirname(__FILE__) + '/../spec_helper'

describe Customer do
  before(:each) do
    @customer = Customer.find(1)
  end

  it "should have agents" do 
  	@customer.should have(1).agents 
  end
  
  it "should have orders" do 
  	@customer.should have(1).orders
  end
  	
end
