require File.dirname(__FILE__) + '/../spec_helper'

describe Customer do
  before(:each) do
    @customer = Customer.new
  end

  it "should be valid" do
    @customer.should be_valid
  end
end
