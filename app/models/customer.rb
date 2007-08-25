class Customer < ActiveRecord::Base
  has_many    :representations
  has_many    :agents, :through => :representations
  has_many    :orders, :select => 'orders.id, orders.created_at, orders.total_amount_payable, orders.order_status_id'
  has_many    :addresses
  has_many 	  :users
 
  belongs_to  :status, :class_name => 'CustomerStatus', :foreign_key => 'status_id'
  belongs_to  :price_type
  belongs_to  :country
  belongs_to  :payment_term
  before_save :check_agent_type
  
  
  validates_presence_of :name, :alternate_name, :phone, :fax
  validates_numericality_of :phone
  
  
  def agent_ids=(id_list)
  	#@todo fill this bit out
  end
  
  
  protected
  def check_agent_type
    is_agent? ? self.type = 'Agent' : self.type = 'Customer'
  end
end
