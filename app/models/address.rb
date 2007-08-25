class Address < ActiveRecord::Base
  belongs_to :country
  belongs_to :customer
  
  def self.default_billing
    find(:first, :conditions => 'is_default_billing = 1')
  end

  def self.default_shipping
    find(:first, :conditions => 'is_default_shipping = 1')
  end
  
  def is_default_shipping?(customer) 
  	true
  end
  
  def is_default_billing?(customer)
    true
  end



end
