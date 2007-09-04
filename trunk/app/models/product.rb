class Product < ActiveRecord::Base
  has_many :pricings
  has_many :price_types, :through => :pricings
  has_many :category_product_links 
  has_many :categories, :through => :category_product_links
  belongs_to :order_line
  
  #used to return the price of the product, pass in PriceType, get out price value
  #called in OrderLine calculation
  def get_pricing(price_type)
    if !pricing = pricings.find(:first, :conditions => ['price_type_id = ?', price_type.id] ) 
    	raise 'Price for product '+self.id.to_s+' cannot be found for given price type '+price_type.id.to_s 
    end
    return pricing
  end
  
  def self.find_visible()
  	if !f = find(:all, :conditions => 'visible = 1')
  		raise 'No visible products found'
  	end
  	return f
  end
end
