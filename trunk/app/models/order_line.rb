class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  
  attr_protected :discount_applied
  
  def validate 
    if self.qty_ordered.to_i < 10 
      errors.add_to_base('You must order more than 10')
    end
  end 
  
  def get_price(price_type)
    self.price_as_ordered = self.product.get_price(price_type) * self.qty_ordered
  end
end
