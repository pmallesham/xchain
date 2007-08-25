require File.dirname(__FILE__) + '/../spec_helper'

describe CategoryProductLink do
  before(:each) do
    @category_product_link = CategoryProductLink.new
  end

  it "should be valid" do
    @category_product_link.should be_valid
  end
end
