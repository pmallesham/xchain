require File.dirname(__FILE__) + '/../spec_helper'

describe Product, " when using Product ID 1 " do
 before(:each) do
    @product = Product.find(1)
  end

  it "should be valid" do
    @product.should be_valid
  end
  
  
end
