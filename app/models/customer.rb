class Customer < ActiveRecord::Base
  has_many    :agents, :through => :represntation
  has_many    :orders 
  belongs_to  :representation
  belongs_to  :customer_status
  belongs_to  :price_type
  belongs_to  :country
end
