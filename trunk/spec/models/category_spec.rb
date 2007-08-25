require File.dirname(__FILE__) + '/../spec_helper'

describe Category do
  fixtures :categories, :products, :category_product_links
  before(:each) do
    @category = Category.find(1)
  end

  it "should have a title" do
    @category.title?.should == true
  end
  
  it "should have two category_product_links" do 
    @category.should have(2).category_product_links
  end
  
  it "should have two products" do 
    @category.products.count.should == 2
  end
end
