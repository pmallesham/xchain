class Address < ActiveRecord::Base

  def self.default_billing
    find(:first, :conditions => 'addressables.address_type = 0 AND addressables.is_default = 1')
  end

  def self.default_shipping
    find(:first, :conditions => 'addressables.address_type = 1 AND addressables.is_default = 1')
  end

end
