require File.dirname(__FILE__) + '/../spec_helper'

describe OrderLine, "with valid order line " do
  before(:each) do
    @order_line = OrderLine.find(1)
  end

  it "should be valid" do
    @order_line.should be_valid
  end
  
  it "should respond to get_price " do 
    @order_line.respond_to?(:get_price).should == true
  end 
  
  it "should return a price of for x price type and y qty with a non-discountable price type "
  # do 
   # @order_line.get_price(PriceType.find(1)).should == 123.00
  #end
  
  it "should return a price of for x price type and y qty with a discountable price type " do 
    @order_line.get_price(PriceType.find(1)).should == 92.25
  end
  
  
  it "should after changing qty return a different price" do
    @order_line.qty_ordered = 200
    @order_line.get_price(PriceType.find(1)).should == 184.5
  end
  
  it "should return correct discount levels"

end
