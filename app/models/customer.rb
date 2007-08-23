class Customer < ActiveRecord::Base
  has_many    :representations
  has_many    :agents, :through => :representations
  has_many    :orders, :select => 'orders.id, orders.created_at, orders.total_amount_payable, orders.order_status_id'
  has_many    :addresses, :through => :addressables
  has_many    :addressables
  has_many 	  :users
 
  belongs_to  :status, :class_name => 'CustomerStatus', :foreign_key => 'status_id'
  belongs_to  :price_type
  belongs_to  :country
  belongs_to  :payment_term
  
  validates_presence_of :name, :alternate_name, :phone, :fax
  
  def agent_ids=(id_list)
  	#@todo fill this bit out
  end
  
  
end
