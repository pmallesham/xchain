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
  	@cart.line_items.size.should == 1
  end
  
  it "should when filling with the same product, never increase in line item count, just qty " do 
  	@cart.add_product(Product.find(4)).should == true
  	@cart.line_items.size.should == 1
  	@cart.add_product(Product.find(4)).should == true
  	@cart.line_items.size.should == 1

  end
 
  it "should be return a total item qty greater than line_item.size " do 
    @cart.add_product(Product.find(4), 15).should == true
  	@cart.line_items.size.should == 1
  	@cart.add_product(Product.find(4), 15).should == true
  	@cart.line_items.size.should == 1
  	@cart.total_item_qty.should == 30
  end
  
  it "should be able to be associated with a user" do 
  	@cart.user = User.find(1)
  	@cart.save
  	User.find(1).carts.include?(@cart).should == true
  end  	
	    
end

