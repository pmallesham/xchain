require File.dirname(__FILE__) + '/../spec_helper'


describe Order, "when creating a new order" do 
  fixtures :orders, :order_lines, :customers, :addresses, :addressables, :products
  
  it "should be able to instantiate" do 
    @order = Order.new
  end

  it "should default to draft status" do 
    @order = Order.new
    @order.order_status_id.should == 10
  end
  
  it "should be able to prefill an address" do 
    @customer = Customer.find(1)
    @order = Order.new
    @order.should respond_to(:prefill_address)
    @order.prefill_address(Customer.find(1))
    @order.billing_address.should eql(@customer.addresses.default_billing.address)
    @order.billing_city.should eql(@customer.addresses.default_billing.city)
    @order.billing_postcode.should eql(@customer.addresses.default_billing.postcode)
    @order.shipping_address.should eql(@customer.addresses.default_shipping.address)
    @order.shipping_city.should eql(@customer.addresses.default_shipping.city)
    @order.shipping_postcode.should eql(@customer.addresses.default_shipping.postcode)
  end
  
  it "should have a default price type matching customer price type" do 
    
  end
  
  it "should calculate return 0 dollars" do 
    @order = Order.new
    @order.prefill_address(Customer.find(1))
    @order.calculate
    #@order.tax_amount.should eql(0)  @todo
    @order.total_amount_payable.should eql(0.0)
  end
  
  it "should throw an error that it doesn't have line items" do 
    @order = Order.new
    @order.prefill_address(Customer.find(1))
    @order.should have(1).errors_on(:base)
  end
  
  it "should be able to be edited" do 
    
  end
  
  it "should be able to have an order line added" do 
    @order = Order.new
    @order.prefill_address(Customer.find(1))
    @order.order_lines.create(:qty_ordered => 1, :product => Product.find(1))
    @order.order_lines.size.should eql(1)
    @order.calculate.should eql(1.23)
    @order.total_amount_payable.should eql(1.23)
  end
  
  
end

describe Order, "when finding existing order" do
  fixtures :orders, :order_lines, :customers
  before(:each) do
    @order = Order.find(1)
  end

  it "should have id = 1" do
    @order.id.should eql(1)
  end
  
  it "should have a purchase order number" do 
    @order.purchase_order_number.should eql('PO-001')
  end
  
  it "should have 3 order lines" do 
    @order.order_lines.count.should eql(3)
  end
  
  it "should have a billing address" do
    @order.billing_address.should == '1001 Acmeville Rd, Acme Industry Centre'
    @order.billing_city.should == 'Acmeville'
    @order.billing_postcode.should == 'AM1001'
  end
  
  it "should have a customer" do 
    @order.customer.name.should == 'Acme Corp'
  end
  
  
end

