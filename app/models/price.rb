class Price < ActiveRecord::Base
  belongs_to :product
  belongs_to :price_type
  
  #used to return the price of the product, pass in PriceType, get out price value
  #called in OrderLine calculation
  def self.get_price(price_type)
    find(:first, :conditions => ['price_type_id = ?', price_type.id] ).price
  end
end
