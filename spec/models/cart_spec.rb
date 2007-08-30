require File.dirname(__FILE__) + '/../spec_helper'

describe Cart, "when starting a new browsing session" do
  before(:each) do
    @cart = Cart.new
  end

  it "should be valid" do
    @cart.should be_valid
  end
  
  it "should be able to be filled by products" do 
  	@cart.add_product(Product.find(4)).should == true
  	@cart.user = User.find(1)
  	@cart.line_items.size.should == 1
  end
  
  it "should be return a total item qty"
  
  it "should be able to be associated with a user"
  
  it "should be able to create an order with a user "
  
end

describe Cart, "when resuming a browsing session" do 
  before(:each) do 
    @cart = Cart.new
  end
   
  "it should have items from previous session"
  
end
