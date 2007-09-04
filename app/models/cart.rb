class Cart < ActiveRecord::Base
  has_many :line_items, :class_name => 'CartLineItem', :foreign_key => 'cart_id'
  belongs_to :user
  
  def add_product(product, qty = 10)
  	self.line_items.each do |li|
  		if li.product == product 
  			li.qty += qty
  			self.save	
  			return true
  		end
  	end
    self.line_items << CartLineItem.create(:qty => qty, :product => product)
    self.save
    return true
  end
  
  def total_item_qty 
  	total_items = 0 
  	self.line_items.each { |li| total_items += li.qty }
  	total_items
  end	
  	
  #proxy to user.customer
  def customer
    user.customer
  end
end
