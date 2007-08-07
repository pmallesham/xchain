class Order < ActiveRecord::Base
  has_many :order_status_histories
  has_many :order_lines, :select => 'id, description', :include => :product, :order => 'products.id ASC'
  has_many :next_statuses, :class_name => "OrderStatus", :finder_sql => 'SELECT order_statuses.id as data, order_statuses.name as label FROM order_statuses '
  belongs_to :order_status
  belongs_to :customer
  belongs_to :price_type
  
  belongs_to :current_status, :class_name => 'OrderStatus', :foreign_key => 'order_status_id'
  belongs_to :previous_status, :class_name => 'OrderStatus', :foreign_key => 'previous_order_status_id'

  before_save   :auto_calculate
  before_create :set_draft_status
  
  validates_presence_of :purchase_order_number
  validates_associated :order_lines

  def validate
    if self.order_lines.size == 0 
      errors.add_to_base 'You must have at least one line item'
    end
  end
  
  def prefill_address(customer)
    self.customer_id = customer.id
    
    billing_address       = customer.addresses.default_billing
    self.billing_address  = billing_address.address
    self.billing_city     = billing_address.city
    self.billing_postcode = billing_address.postcode
    
    
  end
  
  def auto_calculate
    calculate if order_status_id == 10 
  end
  
  def calculate
  
  
    #we get the shipping amount before doing the transaction so we can log any failures. 
    #begin 
  #    shipment             = Shipment.new
  #    tmp_shipment_amount  = shipment.get_shipping_amount(
  #                           :weight => self.shipping_weight,
  #                           :dest_city => self.shipping_city,
  #                           :dest_postal_code => self.shipping_postcode,
  #                           :dest_country => self.shipping_country.code
  #                           )
   # rescue
   #   return false
    #end
    self.transaction do 
      @order_lines_amount = 0.00
      for ol in self.order_lines  
        @order_lines_amount += ol.get_price(self.customer.price_type)
      end
      self.sub_total = @order_lines_amount
      self.shipping_total = tmp_shipment_amount
      self.shipping_weight = self.shipping_weight
      self.total_amount_payable = @order_lines_amount
      
    end
  end
  
  def sub_total
    sub_total = 0
    for ol in self.order_lines 
      sub_total = ol.qty_ordered * ol.price_as_ordered
    end
    sub_total
  end
  
  def shipping_weight
    return 12.0
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
    self.order_status_id = status_history.id
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
  	#super
  	
  end
  
 # def next_statuses
 # 	
 # 	self.next = self.order_status.find_next_available_statuses()
 # end
  
  
end
