class Product < ActiveRecord::Base
  has_many :pricings
  has_many :price_types, :through => :pricings
  has_many :category_product_links 
  has_many :categories, :through => :category_product_links
  belongs_to :order_line
  
  #used to return the price of the product, pass in PriceType, get out price value
  #called in OrderLine calculation
  def get_pricing(price_type)
    pricings.find(:first, :conditions => ['price_type_id = ?', price_type.id] )
  end
end
