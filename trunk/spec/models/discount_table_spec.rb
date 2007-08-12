require File.dirname(__FILE__) + '/../spec_helper'

describe DiscountTable do
  before(:each) do
    @discount_table = DiscountTable.new
  end

  it "should be valid" do
    @discount_table.should be_valid
  end
end
