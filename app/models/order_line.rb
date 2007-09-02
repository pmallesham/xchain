class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  
  attr_protected :discount_applied
  
  def validate 
    if self.qty_ordered.to_i < 10 
      errors.add_to_base('You must order more than 10')
    end
  end 
  
  # We need to determine the pricing model for the order (taken from price type)
  # then look up the unit price for the product according to the price type
  # finally get the discount for the volume at that price type. 
  def get_price(price_type)
    @pricing = product.get_pricing(price_type)
    self.price_as_ordered = get_unit_price  * get_discount
    self.price_as_ordered * self.qty_ordered
  end
  
  protected
  def get_unit_price
    @pricing.get_unit_price()
  end
  
  def get_discount
    @pricing.discount.get_discount(self.qty_ordered)
  end
end
