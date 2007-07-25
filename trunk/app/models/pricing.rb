class Pricing < ActiveRecord::Base
  belongs_to :product
  belongs_to :price_type
end
