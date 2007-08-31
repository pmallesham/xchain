class Cart < ActiveRecord::Base
  has_many :line_items, :class_name => 'CartLineItem', :foreign_key => 'cart_id'
  belongs_to :user
  
  def add_product(product, qty = 10)
    self.line_items << CartLineItem.create(:qty => qty, :product => product)
    self.save
    return true
  end
  
  #proxy to user.customer
  def customer
    user.customer
  end
end
