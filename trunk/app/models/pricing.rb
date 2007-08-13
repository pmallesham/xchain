class Pricing < ActiveRecord::Base
  set_table_name 'pricing'
  belongs_to :product
  belongs_to :price_type
  belongs_to :discount
  
  def get_unit_price
    return price
  end
  
  
end
