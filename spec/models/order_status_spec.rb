require File.dirname(__FILE__) + '/../spec_helper'

describe OrderStatus do
  
  before(:each) do
    @order_status = OrderStatus.new
  end

  it "should be able to find standard statuses" do 
    @order_status = OrderStatus.find(10)
    @order_status.name.should == 'Draft'
  end
end

context OrderStatus, "using a draft order status with no super user" do 
  
  before(:each) do 
    @order_status = OrderStatus.find(10)
  end
  
  it "should have a list of next available status, when flow next is false, only including itself and the next higher status" do
    s = @order_status.find_next_available_statuses
    s.size.should == 2
    s.include?(@order_status).should == true
    s.include?(OrderStatus.find_by_name('Submitted - Pending Payment')).should == true
  end
  
  it "should not have all statuses available" do
    s = @order_status.find_next_available_statuses    
    s.size.should_not == OrderStatus.count
  end
  
end


context OrderStatus, "using a draft order status a super user" do 
  
  before(:each) do 
    @order_status = OrderStatus.find(10)
  end
  
  it "should have a list of all available statuses" do
    s = @order_status.find_next_available_statuses(true)
    s.size.should == OrderStatus.count
  end
  
end