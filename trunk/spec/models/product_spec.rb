require File.dirname(__FILE__) + '/../spec_helper'

describe Product, " when using Product ID 1 " do
 before(:each) do
    @product = Product.find(1)
  end

  it "should be valid" do
    @product.should be_valid
  end
  
  
end


describe Product, "when looking at a total collection" do 
	before(:each) do 
		@products = Product.find(:all)
	end
	
	it "should have 5 items" do 
		@products.size.should == 5
	end
end


describe Product, "when looking at a only visible items" do 
	before(:each) do 
		@products = Product.find_visible
	end
	
	it "should have 4 items" do 
		@products.size.should == 4
	end
end 