class Order < ActiveRecord::Base
  has_many :order_status_histories
  has_many :order_lines, :select => 'id, description', :include => :product, :order => 'products.id ASC'
  has_many :next_statuses, :class_name => "OrderStatus", :finder_sql => 'SELECT order_statuses.id as data, order_statuses.name as label FROM order_statuses '
  belongs_to :order_status
  belongs_to :customer
  belongs_to :price_type
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by_user_id'
  belongs_to :billing_country, :class_name => 'Country', :foreign_key => 'billing_country_id'
  belongs_to :shipping_country, :class_name => 'Country', :foreign_key => 'shipping_country_id'
  belongs_to :current_status, :class_name => 'OrderStatus', :foreign_key => 'order_status_id'
  belongs_to :previous_status, :class_name => 'OrderStatus', :foreign_key => 'previous_order_status_id'
  belongs_to :payment_term

  before_save   :auto_calculate
  
  validates_presence_of :purchase_order_number
  
  def initialize(args = {})
    super
    self.order_status_id = 10 
    self.order_status_histories.create(:order_status_id => 10, :comment => 'Created new order')
    if customer 
      self.payment_term_id = customer.payment_term_id
    end
  end
  
  
  
  def validate
    if self.order_lines.size == 0 
      errors.add_to_base 'You must have at least one line item'
    end
  end
  
  def prefill_address(customer)
    self.customer_id = customer.id
    billing_address         = customer.addresses.default_billing
    shipping_address        = customer.addresses.default_shipping
    
    self.billing_address    = billing_address.address
    self.billing_city       = billing_address.city
    self.billing_postcode   = billing_address.postcode
    self.billing_country_id = billing_address.country_id
    self.shipping_address  = shipping_address.address
    self.shipping_city     = shipping_address.city
    self.shipping_postcode = shipping_address.postcode
    self.shipping_country_id = shipping_address.country_id
  
  end
  
  def auto_calculate
    calculate if order_status_id == 10 
  end
  
  def calculate
    tmp_shipment_amount = 0
    self.shipping_weight = 0
    
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

  def set_status(status, message)
    self.order_status = status
    self.order_status_histories << OrderStatusHistory.create(:order_id => self.order_status_id, :comment => message)
  end
  
  def update_status_history(status_history)
    self.order_status_histories << status_history
    self.order_status_id = status_history.order_status_id
    self.save
  end
  
  def can_review
    self.order_status.id == 10 ? true : false 
  end
  
  def can_edit
    self.order_status.id == 10 ? true : false 
  end
  
  def can_select_payment
    self.order_status.id == 19 ? true : false 
  end
  
  def can_send_payment
    ( self.order_status.id == 14 || self.order_status.id == 20 ) ? true : false
  end
  
  def additional_xml
  	next_statuses
  end
  
  protected



  
  
end
