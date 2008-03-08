class Order < ActiveRecord::Base
  DRAFT              = 10 
  PENDING_REVIEW     = 12
  PAYMENT_SELECTION  = 19
  PENDING_PAYMENT    = 20  #MAYBE THIS CAN BE REMOVED
  PAYMENT_SENT       = 22
  PAYMENT_RECEIVED   = 24
  FINALISED          = 25  #NEW STATUS, One of the big three. CREATED FINALISED SHIPPED RECEIVED
  PAYMENT_TRANSFER   = 1
  PAYMENT_PAY_ONLINE = 2
  
  has_many :order_status_histories
  has_many :order_lines
  has_many :next_statuses, :class_name => "OrderStatus", :finder_sql => 'SELECT order_statuses.id as data, order_statuses.name as label FROM order_statuses '
  belongs_to :status, :class_name => 'OrderStatus', :foreign_key => 'order_status_id'
  belongs_to :customer
  belongs_to :price_type
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by_user_id'
  belongs_to :billing_country, :class_name => 'Country', :foreign_key => 'billing_country_id'
  belongs_to :shipping_country, :class_name => 'Country', :foreign_key => 'shipping_country_id'
  belongs_to :previous_status, :class_name => 'OrderStatus', :foreign_key => 'previous_order_status_id'
  belongs_to :payment_term
  belongs_to :shipping_method

  before_save   :auto_calculate
  
  validates_presence_of :purchase_order_number
  
  def self.find_for_orders_page(opts = {})
    opts.reverse_merge! :order_by => 'status_name'
    sql = "SELECT orders.id, orders.created_at, order_statuses.name as status_name, orders.customer_id, 
                        customers.name as customer_name, orders.created_at, orders.total_amount_pay_online, 
                        countries.name AS country_name
                 FROM orders 
                 INNER JOIN order_statuses ON ( orders.order_status_id = order_statuses.id)
                 INNER JOIN customers ON ( orders.customer_id = customers.id)
                 INNER JOIN countries ON ( countries.id = customers.country_id )"
    case opts[:order_by]
      when 'order_id'
        sql << ' ORDER BY orders.id DESC'
      when 'status_name'
        sql << ' ORDER BY order_statuses.id ASC'
      when 'customer_name'
        sql << ' ORDER BY customers.name ASC'
      when 'country_name'
        sql << ' ORDER BY countries.name ASC'
      else
        raise 'Invalid order by '+opts[:order_by]
    end

    find_by_sql(sql)
  end
  
  
  def self.create_from_cart(cart)
    raise exception if !cart.user
    raise exception if cart.line_items.size == 0 
    o = cart.customer.orders.build(:created_by => cart.user)
    o.prefill_address
    o.source_id = 1
    for item in cart.line_items
      o.order_lines.build(:qty_ordered => item.qty, :product => item.product)
    end
    o.order_status_histories.first.comment = "Created from cart"
    o.purchase_order_number = "Cart"
    return o
  end
  
  #stubs for other methods of creating orders
  def self.create_from_email()
  end
  
  def self.create_from_order_pad()
  end
  
  def self.create_from_service()
  end
  
  def initialize(args = {})
    super
    self.order_status_id = 10 
    self.order_status_histories.build(:order_status_id => 10, :comment => 'Created new order')
  end
  
  def validate
    if self.order_lines.size == 0 
      errors.add_to_base 'You must have at least one line item'
    end
  end


  # Workflow management 
  def place_order!
    self.shipping_method.office_calculated ? set_status(PENDING_REVIEW) : set_status(PAYMENT_SELECTION)
  end
  
  def order_reviewed(comment = '')
    set_status(PAYMENT_SELECTION, comment)
  end
  
  #todo remove customer assignment, not necessary
  def prefill_address()
    raise Exception if !customer.id
    self.payment_term    		= customer.payment_term
    self.price_type				= customer.price_type
    billing_address         = customer.addresses.default_billing
    shipping_address        = customer.addresses.default_shipping
    self.billing_address    = billing_address.address
    self.billing_city       = billing_address.city
    self.billing_postcode   = billing_address.postcode
    self.billing_country_id = billing_address.country_id
    self.shipping_address   = shipping_address.address
    self.shipping_city      = shipping_address.city
    self.shipping_postcode  = shipping_address.postcode
    self.shipping_country_id = shipping_address.country_id
  end

  
  def auto_calculate
    calculate if order_status_id == 10 
  end

  def calculate
  	# there are only two times an order can be calculated, when it's either in draft, or pending review
  	# in any other situation, you can't change the order amount
  	raise 'Attempted to calculate at wrong stage' unless ( order_status_id == 10 || order_status_id == 20 ) 
  	
  	#holding values until shipping calcs are done
    tmp_shipment_amount 	= 0
    self.shipping_weight 	= 0
    
    # must do this in a transaction, otherwise karma and bad things will bite us in the ass
    self.transaction do 
       @order_lines_amount = 0.00
       for ol in self.order_lines  
         @order_lines_amount += ol.get_price(self.customer.price_type)
       end
       self.sub_total             = @order_lines_amount
       self.shipping_amount       = tmp_shipment_amount
       self.tax_amount            = get_tax_amount
       self.shipping_weight       = self.shipping_weight + 1
       self.total_amount_payable  = @order_lines_amount + self.shipping_amount + self.tax_amount 
     end

  end

  def get_tax_amount
    if self.billing_country_id == 2 
      tax_amount = ( self.sub_total + self.shipping_amount ) * 0.125
    else 
      tax_amount = 0
    end
  end
  
  def set_draft_status
    self.set_status(OrderStatus.find_by_name('Draft'), 'Initial creation')
  end

  def set_status(status, message = 'Automated')
    unless status.class == "OrderStatus"
      status = OrderStatus.find(status)
    end
    self.status = status
    self.order_status_histories << OrderStatusHistory.create(:order_id => self.status.id, :comment => message)
  end
  
  def set_payment_method(payment_method_id)
    self.payment_method_id = payment_method_id
    if self.payment_method_id == PAYMENT_TRANSFER
      set_status(PAYMENT_SENT)
    end
  end
  
  # def update_status_history(status_history)
  #    self.order_status_histories << status_history
  #    self.status = status_history.order_status_id
  #    self.save
  #  end
  
  
  def order_reviewed!
  	
  end
  
  def payment_selected!
  	
  end
  
 # def can_review
 #   self.order_status.id == 10 ? true : false 
 # end
  
 # def can_edit
 #   self.order_status.id == 10 ? true : false 
 # end
  
 # def can_select_payment
 #   self.order_status.id == 19 ? true : false 
 # end
  
 # def can_send_payment
 #   ( self.order_status.id == 14 || self.order_status.id == 20 ) ? true : false
 # end
  
 # def additional_xml
 # 	next_statuses
 # end
  
  protected



  
  
end
