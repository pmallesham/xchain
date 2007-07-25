class Pricing < ActiveRecord::Base
  set_table_name 'pricing'
  belongs_to :product
  belongs_to :price_type
end
