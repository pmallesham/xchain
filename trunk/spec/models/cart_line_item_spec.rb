require File.dirname(__FILE__) + '/../spec_helper'

describe CartLineItem do
  before(:each) do
    @cart_line_item = CartLineItem.new
  end

  it "should be valid" do
    @cart_line_item.should be_valid
  end
end
