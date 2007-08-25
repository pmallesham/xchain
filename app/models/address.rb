class Address < ActiveRecord::Base
  belongs_to :country
  belongs_to :customer
  
  validates_presence_of :city, :address
  
  def self.default_billing
    find(:first, :conditions => 'is_default_billing = 1')
  end

  def self.default_shipping
    find(:first, :conditions => 'is_default_shipping = 1')
  end
end
