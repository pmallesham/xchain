#
# GET /orders/
# GET /orders/new;select_customer
# GET /orders/new   {customer id passed in to ?new}
# POST /orders
# {should be at draft order phase}
# To edit an order (customer or agent or manager)
# GET /order/id
# PUT /order/id
# To review an order 

class OrdersController < ApplicationController
  #before_filter :login_required
  before_filter :load_order_object, :except => ['index', 'select_customer', 'new', 'create', 'create_from_cart' ]

  # GET /orders
  def index
    params[:order_status] ? conditions = ['order_status_id = ?', params[:order_status]] : conditions = 'order_status_id < 100'
    @orders = Order.find_for_orders_page
  end
  
  # GET /orders/1
  def show
  	@admin_mode = false
  	
  end
  
  def select_customer
    @order      = Order.new
    @customers  = Customer.find(:all,:select => "customers.id, customers.name, countries.name as country_name", :include => :country, :order => 'customers.name ASC')
  end
  	
  # GET /orders/new?customer_id = 890
  def new
    @customer = Customer.find(params[:customer_id])
    @order = Order.new
    @order.prefill_address(@customer)
    @products = Product.find(:all)
    respond_to do |format| 
     	format.xml { render :xml => @order.to_xml(:dasherize => false, :include => [:customer, :order_lines, :order_status_histories, :order_status, :next_statuses, :price_type]) }
		  format.html { render :action => 'show'}
	  end
  end
  
  # GET /orders/1;edit
  def edit
    @products = Product.find(:all)
  end

  # GET /orders/1;review
  # Allows for editing changes, shipping method, changes, 
  # Change to next status, set to pending payment selection (flow next .. select_payment)
  def review
    @products = Product.find(:all)
  end

  # GET /orders/1;select_payment
  def select_payment
  end
  
  # PUT /orders/1;payment_selection
  def payment_selection
    case params[:commit]
     when 'Pay Via Transfer'
      @order.payment_method_id = 1
      @order.set_status('Payment Sent')
      @order.save
      redirect_to awaiting_payment_order_url(@order)
     when 'Pay Online'
      @order.payment_method_id = 2
      @order.set_status('Pending Payment')
      @order.save
      redirect_to pay_online_order_url(@order)
    end 
  end

  # GET /orders/1;awaiting_payment
  def awaiting_payment
  end

  # GET /orders/1;pay_online
  def pay_online
  end
  

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    @products = Product.find(:all)
    params[:new_line].each do |ol|
      if ol[1].fetch('qty_ordered').to_i > 0
        @order.order_lines << OrderLine.create(:qty_ordered => ol[1].fetch('qty_ordered'), :product_id => ol[1].fetch('product_id'))
      end
    end
    respond_to do |format|
      if @order.save
        flash[:notice] = 'Order was successfully created.'
        
        format.html { redirect_to order_url(@order) }
        format.xml do
          headers["Location"] = order_url(@order)
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors.to_xml }
      end
    end
  end
  
  def create_from_cart
  	cart = Cart.find(params[:cart_id])
  	order = Order.create_from_cart(cart)
  	order.save
  	redirect_to order_url(order)
  end
  
  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @products = Product.find(:all)
    
    respond_to do |format|
      if @order.update_attributes(params[:order]) && OrderLine.update(params[:order_line].keys, params[:order_line].values)
        format.html { redirect_to order_url(@order) }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors.to_xml }        
      end
    end
  end
  
  # PUT /orders/1;update_status
  # PUT /orders/1.xml
  def update_status
    if @order_status_history = OrderStatusHistory.create(params[:order_status_history])
      @order.update_status_history(@order_status_history)
      redirect_to order_url(@order.id) and return false
    else
      render :action => 'show'
    end
  end
  
  
  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    
    respond_to do |format|
      format.html { redirect_to orders_url   }
      format.xml  { render :nothing => true }
    end
  end
  
  private
  def load_order_object
    @order = Order.find(params[:id], :include => [:order_status_histories, :order_lines, :customer, :billing_country, :shipping_country, :price_type, :payment_term])
  end
  
  
end