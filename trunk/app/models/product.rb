class Product < ActiveRecord::Base
  has_many :pricings
  has_many :price_types, :through => :pricings
  belongs_to :order_line
  
end
