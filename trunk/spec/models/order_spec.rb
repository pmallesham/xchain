require File.dirname(__FILE__) + '/../spec_helper'


describe Order, "when creating a new order" do 
 
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
    @customer = Customer.find(1)
    @order = Order.new
    @order.should respond_to(:prefill_address)
    @order.prefill_address(Customer.find(1))
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
  
  
  it "should be able to have an order line added" do 
    @order = Order.new
    @order.prefill_address(Customer.find(1))
    @order.order_lines.create(:qty_ordered => 1, :product => Product.find(1))
    @order.calculate.should eql(1.845)
    @order.total_amount_payable.should eql(1.845)
  end

  it "should when valid and saved, have one order status history item" do 
    @order = Order.new
    @order.prefill_address(Customer.find(1))
    @order.purchase_order_number = 'PO-001'
    @order.order_lines.create(:qty_ordered => 20, :product => Product.find(:first))
    @order.save.should == true
    puts 
    @order.order_status_histories.count.should == 1
  end
  
  it "should when changing to a large quantity, change discount %age" do
    @order = Order.new
    @order.prefill_address(Customer.find(1))
    @order.purchase_order_number = 'PO-001'
    @order.order_lines.create(:qty_ordered => 2000, :product => Product.find(:first))
    @order.save.should == true
    @order.total_amount_payable.to_i.to_s.should == 1845.to_s   #not happy, need to tidy up
  end
  
  it "should have a tax amount of 0 for an export order " do 
    @order = Order.new
    @order.prefill_address(Customer.find(1))
    @order.purchase_order_number = 'PO-001'
    @order.order_lines.create(:qty_ordered => 20, :product => Product.find(:first))
    @order.save.should == true
    @order.total_amount_payable.to_s.should == 24.6.to_s  #again issues with flaots equality. 
  end
  
  it "should have an additional tax of 12.5% for a local (New Zealand) order" do 
    @order = Order.new
    @order.prefill_address(Customer.find(1))
    @order.purchase_order_number = 'PO-001'
    @order.order_lines.create(:qty_ordered => 20, :product => Product.find(:first))
    @order.billing_country_id = 2  #set to NZ. 
    @order.save.should == true
    @order.total_amount_payable.to_s.should == 27.675.to_s  #issues with float equality. 
  end
  
  
  
end

context Order, "new draft order" do 
  before(:each) do 
    @order = Order.new :customer => Customer.find(1), :created_by => User.find(1)
    @order.purchase_order_number = 'NDO-001'
    @order.order_lines.create(:qty_ordered => 20, :product => Product.find(:first))
    @order.save.should == true
  end
  
  it "should have a set of default payment terms" do 
    @order.payment_term_id.should == 1
  end
  
  it "should be able to be changed to a new status" do 
    @order.set_status(OrderStatus.find(12), 'Ready to order')
    @order.order_status_histories.count.should == 2
    @order.order_status_id.should == 12
  end
  
  it "should be able to have it's address changed" do 
    address = '10023 Acmetown Rd'
    city = "Acmeville 2"
    postcode = 'AM10023'
    @order.billing_address = address
    @order.billing_city = city
    @order.billing_postcode = postcode
    @order.save
    check_id = @order.id

    @order = Order.find(check_id)
    @order.billing_address.should == address
    @order.billing_city.should == city
    @order.billing_postcode.should == postcode
  end
  
  it "should have an associated user who created it" do 
    @order.created_by.should == User.find(1)
  end
  
  it "should belong to the correct customer" do 
    @order.customer.should == Customer.find(1)
  end
  
  it "should be in the order collection list" do 
    check_id = @order.id
    Order.find(:all).include?(Order.find(check_id)).should == true
  end
end


context Order, "with a single, invalid order line added " do 
  before(:each) do 
     @order = Order.new
     @order.prefill_address(Customer.find(1))
     @order.order_lines.create(:qty_ordered => 1, :product => Product.find(1))
     @order.purchase_order_number = "PO-001"
  end
  
  it "should calculate to a correct amount" do 
    @order.calculate.should eql(1.845)
    @order.total_amount_payable.should eql(1.845)
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

context Order, "when creating from a cart " do 
  before(:each) do 
    @cart = Cart.new
    @cart.add_product(Product.find(4))
    @cart.user = User.find(1)
    @order = Order.create_from_cart(@cart)
  end

  it "should be able to be created with a valid cart" do 
    #@order.should_be valid
  end
  
  it "should be associated with Customer 1" do 
    @order.customer_id.should == 1
  end
  
  it "should prefill with Customer 1's address details"
  
  it "should have x line items"
  
  it "should have the correct product ids"
  
  it "should calculate with a sub_total of x"
  
  it "should be in Draft status "
  
  it "should have a source_id of 1"
  
  it "should have in order status history, comment of created from Cart"
  
end
  
  




describe Order, "when finding existing order" do
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

