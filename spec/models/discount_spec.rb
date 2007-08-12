require File.dirname(__FILE__) + '/../spec_helper'

describe Discount, " when loading existing discount" do
  fixtures :discounts, :discount_tables, :pricing
  before(:each) do
    @discount = Discount.find(1)
  end

  it "should belong to a pricing" do
    @discount.pricing.count.should == 9
  end
  
  it "should have a name" do 
    @discount.rule_name.should == 'Example A'
  end
  
  it "should have a discount table" do 
    @discount.discount_tables.count.should == 3
  end
  
  it "should respond to get discount" do 
    @discount.respond_to?(:get_discount).should == true
  end
  
end
