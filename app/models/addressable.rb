class Addressable < ActiveRecord::Base
  belongs_to :customer
  belongs_to :address
  
  
  def type
    self.address_type == 0 ? 'billing' : 'shipping'
  end
  
end
