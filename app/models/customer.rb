class Customer < ActiveRecord::Base
  has_many    :representations
  has_many    :agents, :through => :representations
  has_many    :orders
  has_many    :addresses
  has_many 	  :users
 
  has_one   :default_billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  has_one   :default_shipping_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  
 
  belongs_to  :status, :class_name => 'CustomerStatus', :foreign_key => 'status_id'
  belongs_to  :price_type
  belongs_to  :country
  belongs_to  :payment_term
  before_save :check_agent_type
  
  validates_presence_of :name, :alternate_name, :phone, :country_id
  #validates_numericality_of :phone
  
  def self.find_for_list()
    find(:all, 
         :select => 'customers.id, customers.name, customers.phone, customers.email, countries.iso_code, countries.name, customer_statuses.name', 
         :include => [:country[:iso_code, :name], :status[:name]], 
         :order => 'customers.id DESC')
  end
  
  def agent_ids=(id_list)
  	#@todo fill this bit out
  end
  
  
  protected
  def check_agent_type
    is_agent? ? self.type = 'Agent' : self.type = 'Customer'
  end
end
