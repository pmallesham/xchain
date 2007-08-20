class Customer < ActiveRecord::Base
  has_many    :agents, :through => :represntation
  has_many    :orders, :select => 'orders.id, orders.created_at, orders.total_amount_payable, orders.order_status_id'
  has_many    :addresses, :through => :addressables
  has_many    :addressables
  belongs_to  :representation
  belongs_to  :customer_status
  belongs_to  :price_type
  belongs_to  :country
  belongs_to  :payment_term
  
end
