class Category < ActiveRecord::Base
  has_many :category_product_links
  has_many :products, :through => :category_product_links
end
