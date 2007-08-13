require File.dirname(__FILE__) + '/../spec_helper'

describe Discount, " when loading existing discount" do
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
  
  it "should return a discount of 1.5 for a quantity of 5" do
    @discount.get_discount(5).should == 1.5
  end
  
  it "should return a discount of 1 for a quantity of 20" do
    @discount.get_discount(20).should == 1
  end
  
  it "should return a max discount of 0.25 for a quantity of 10000" do
    @discount.get_discount(10000).should == 0.75
  end
  
end
