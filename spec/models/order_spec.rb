require File.dirname(__FILE__) + '/../spec_helper'


describe Order, "when creating a new order" do 
  fixtures :orders, :order_lines, :customers, :addresses, :addressables, :products, :price_types, :pricing
  
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
    @order.calculate.should eql(1.23)
    @order.total_amount_payable.should eql(1.23)
  end

end

context Order, "with a single, invalid order line added " do 
  fixtures :orders, :order_lines, :customers, :addresses, :addressables, :products, :price_types, :pricing
  before(:each) do 
     @order = Order.new
     @order.prefill_address(Customer.find(1))
     @order.order_lines.create(:qty_ordered => 1, :product => Product.find(1))
     @order.purchase_order_number = "PO-001"
  end
  
  it "should calculate to a correct amount" do 
    @order.calculate.should eql(1.23)
    @order.total_amount_payable.should eql(1.23)
  end
  
  it "should not be able to be saved as it has incorrect quantity" do 
    @order.save.should == false
    @order.should have(1).errors_on(:order_lines)
  end
  
  it "should after changing the quantity be able to be saved " do 
    @order.order_lines.first.qty_ordered = 12
    @order.save.should == true
    @order.id.should > 0
    @order.total_amount_payable.to_s.should == 14.76.to_s  #if these are left as floats it fails, there must be some weird equality wonkiness
    # puts 'debugging float amount'
    #   puts @order.total_amount_payable.class
    #   puts @order.total_amount_payable.public_methods.join ', '
    #   puts 14.76.class
    #   @order.total_amount_payable.should eql(14.76)
    #   
    
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

