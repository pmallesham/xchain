class Cart < ActiveRecord::Base
  has_many :line_items, :class_name => 'CartLineItem', :foreign_key => 'cart_id'
  belongs_to :user
  
  def add_product(product)
    self.line_items << CartLineItem.create(:qty => 1, :product => product)
    self.save
    return true
  end
  
  #proxy to user.customer
  def customer
    user.customer
  end
end
