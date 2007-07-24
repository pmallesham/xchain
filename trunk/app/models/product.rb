class Product < ActiveRecord::Base
  has_many :prices 
  has_many :price_types, :through => :prices
  belongs_to :order_line
  
end
