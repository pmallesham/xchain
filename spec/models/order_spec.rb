require File.dirname(__FILE__) + '/../spec_helper'


describe Order, "when creating a new order" do 
  before(:each) do 
  	@customer = Customer.find(1)
    @order = @customer.orders.build
    @order.prefill_address
  end
 
  
  it "should default to draft status" do 
    @order.order_status_id.should == 10
  end
  
  it "should be able to prefill an address" do 
  	@order.billing_address.should eql(@customer.addresses.default_billing.address)
    @order.billing_city.should eql(@customer.addresses.default_billing.city)
    @order.billing_postcode.should eql(@customer.addresses.default_billing.postcode)
    @order.shipping_address.should eql(@customer.addresses.default_shipping.address)
    @order.shipping_city.should eql(@customer.addresses.default_shipping.city)
    @order.shipping_postcode.should eql(@customer.addresses.default_shipping.postcode)
  end
  
  it "should have a default price type matching customer price type" do 
  	@order.price_type.should eql(@customer.price_type)
  end
  
  it "should calculate return 0 dollars" do 
    @order.calculate
    @order.total_amount_payable.should eql(0.0)
  end
  
  it "should throw an error that it doesn't have line items" do 
    @order.save
    @order.should have(1).errors_on(:base)
  end
  
  it "should be able to have an order line added" do 
    @order.order_lines.build(:qty_ordered => 1, :product => Product.find(1))
    @order.calculate.to_s.should == "1.845"
    @order.total_amount_payable.to_s.should == "1.845"
  end

  it "should when valid and saved, have one order status history item" do 
    @order.purchase_order_number = 'PO-001'
    @order.order_lines.build(:qty_ordered => 20, :product => Product.find(:first))
    @order.save.should == true
    @order.order_status_histories.count.should == 1
  end
  
  it "should when changing to a large quantity, change discount %age" do
    @order.purchase_order_number = 'PO-001'
    @order.order_lines.build(:qty_ordered => 2000, :product => Product.find(:first))
    @order.save.should == true
    @order.total_amount_payable.to_i.to_s.should == "1845"   #not happy, need to tidy up
  end
  
  it "should have a tax amount of 0 for an export order " do 
    @order.purchase_order_number = 'PO-001'
    @order.order_lines.build(:qty_ordered => 20, :product => Product.find(:first))
    @order.save.should == true
    @order.total_amount_payable.to_s.should == 24.6.to_s  #again issues with flaots equality. 
  end
  
  it "should have an additional tax of 12.5% for a local (New Zealand) order" do 
    @order.purchase_order_number = 'PO-001'
    @order.order_lines.build(:qty_ordered => 20, :product => Product.find(:first))
    @order.billing_country_id = 2  #set to NZ. 
    @order.save.should == true
    @order.total_amount_payable.to_s.should == 27.675.to_s  #issues with float equality. 
  end
  
  
  
end

context Order, "new draft order" do 
  before(:each) do 
    @customer = Customer.find(1)
    @order = @customer.orders.build(:created_by => User.find(1))
    @order.prefill_address
    @order.purchase_order_number = 'NDO-001'
    @order.order_lines.build(:qty_ordered => 20, :product => Product.find(:first))
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
     @customer = Customer.find(1)
     @order = @customer.orders.create
     @order.order_lines.build(:qty_ordered => 1, :product => Product.find(1))
     @order.purchase_order_number = "PO-001"
  end
  
  it "should calculate to a correct amount" do 
    @order.calculate.to_s.should == "1.845"
    @order.total_amount_payable.to_s.should == "1.845"
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
    @cart.add_product(Product.find(4), 10)
    @cart.user = User.find(1)
    @order = Order.create_from_cart(@cart)
  end

  it "should remove the cart from active cart collection"
# do 
#  	@cart.checked_out?.should == true
#  	Cart.find_open_cart(User.find(1))
#  end
  
  it "should be able to be created with a valid cart" do 
    #@order.should_be valid
  end
  
  it "should be associated with Customer 1" do 
    @order.customer_id.should == 1
  end
  
  it "should prefill with Customer 1's address details" do 
	@order.billing_address.should eql(@cart.customer.addresses.default_billing.address)
  end	
	  
  it "should have 1 line items" do 
    @order.order_lines.size.should == 1
  end
  
  it "should have the correct product id" do 
  	@order.order_lines.first.product_id.should == 4
  end
  
  it "should calculate with a sub_total of 8985" do 
  	@order.save
  	@order.sub_total.should == 8985.0
  end
  
  it "should be in Draft status " do 
  	@order.status.id.should == 10 
  end
  
  it "should have a source_id of 1" do 
  	@order.source_id.should == 1
  end
  
  it "should have in order status history, comment of created from Cart" do 
  	@order.order_status_histories.first.comment.should == 'Created from cart'
  end
  	
end


#  Order status flow is (now)
#    
#   Draft ->  [ Pending Review || Payment Selection ] -> Payment Method Chosen -> [ ]
#   Ordering Complete -> [ Hold Production || Sent to Warehouse ] -> [ Waiting for Parts || In manufacturing 
#   || Ready for shipping ] -> Shipped -> Received -> Archived
#   
#   * -> Cancelled
#

context Order, "Order when verifying status flow for custom shipping " do
	
	it "when draft, should jump to pending review " do 
    @order = Order.find(1)
		@order.shipping_method = ShippingMethod.find_by_name('Custom')
		@order.place_order!
		@order.status.name.should == 'Order Pending Review'
	end
	
	it "when reviewed, will go to payment selection " do 
	  @order = Order.find(1)
		@order.shipping_method = ShippingMethod.find_by_name('Custom')
		@order.place_order!
		@order.order_reviewed
		@order.status.name.should == 'Order Placed - Pending Payment Selection'
	end
	
	it "when payment method selected, will go to order process complete " do 
	  @order = Order.find(1)
		@order.shipping_method = ShippingMethod.find_by_name('Custom')
		@order.place_order!
		@order.order_reviewed
		@order.set_payment_method(Order::PAYMENT_TRANSFER)
		@order.status.name.should == 'Submitted - Payment Sent'
	end
	
end

context Order, "Order when verifying status flow for standard shipping " do
	
	it "when draft, should jump to payment selection " do 
		@order = Order.find(1)
		@order.shipping_method = ShippingMethod.find_by_name('UPS SCS')
		@order.place_order!
		@order.status.name.should == 'Order Placed - Pending Payment Selection'
	end
	
	it "when payment method selected, will go to order finalised" do 
	  @order = Order.find(1)
		@order.shipping_method = ShippingMethod.find_by_name('UPS SCS')
		@order.place_order!
		@order.status.name.should == 'Order Placed - Pending Payment Selection'
		@order.set_payment_method(Order::PAYMENT_TRANSFER)
		@order.status.name.should == 'Submitted - Payment Sent'
	end

end

context Order, "Order when using finder for Order Listing" do 
  it "should only return limited columns [id, status_name, customer_name, customer_id, country_name, total_amount_pay_online, date_created]" do 
    @orders = Order.find_for_orders_page
    @orders.first.id.should_not == nil
    @orders.first.status_name.should_not == nil
    @orders.first.customer_name.should_not == nil
    @orders.first.country_name.should_not == nil
    @orders.first.total_amount_pay_online.should_not == nil
    @orders.first.created_at.should_not == nil
    
    %w(date_updated created_by_id tax_amount).each do |col|
      @orders.first[col].should == nil
    end
  end
  
  it "should by default be ordered by status" do 
    @orders = Order.find_for_orders_page
    check = false; 
    last_order = nil
    first_order_id = @orders.first.id
    @orders.each do |o|
      unless o.id == first_order_id
        if last_order == nil
          last_order = @orders.first
        end
       OrderStatus.find_by_name(o.status_name).id.should >= OrderStatus.find_by_name(last_order.status_name).id
      end
      last_order = o
    end
  end
  
  it "should accept the symbol :order_by and order_id, and order by id descending" do 
    @orders = Order.find_for_orders_page :order_by => 'order_id'
    last_order = nil
    @orders.each do |o|
      unless o == @orders.first
        if last_order == nil
          last_order = @orders.first
        end
        o.id.should < last_order.id
      end
      last_order = o
    end
  end
  
  it "should accept the symbol :order_by and customer_name, and order by customer name alphabetically ascending" do
    @orders = Order.find_for_orders_page :order_by => 'customer_name'
    last_order = nil
    @orders.each do |o|
      unless o == @orders.first
        if last_order == nil
          last_order = @orders.first
        end
        o.customer_name > last_order.customer_name
      end
      last_order = o
    end
  end
  
  
  it "should accept the symbol :order_by and country_name, and order by country name alphabetically ascending" do
    @orders = Order.find_for_orders_page :order_by => 'country_name'
    last_order = nil
    @orders.each do |o|
      unless o == @orders.first
        if last_order == nil
          last_order = @orders.first
        end
        o.customer_name > last_order.customer_name
      end
      last_order = o
    end
  end
  
end

=begin

context Order, "when customer is on strict pay before production terms" do 
	
	it "when in payment selection mode should only allow pay online"
	# do
	#	@customer = Customer.find(1)
	#	@customer.pay_online = true
	#	@customer.pay_transfer = false
    #		@customer.pay_by_terms = false
	#	@customer.order....
		
	#	@order.allowed_payment_methods.should == ['ONLINE']
    #end

end

context Order, "when customer is on pay online, or pay via transfer terms " do 
	
	it "when in payment selection mode, should only allow pay online or via transfer terms" 

end

context Order, "when customer has all payment terms open" do 
	
	it "when in payment selection mode, should allow all options"
	
end

context Order, "when unpaid " do 
	
	it "should allow payments to order"

	it "should exist in unpaid orders collection"

end
=end

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

