class ChangeAddressablesToAddresses < ActiveRecord::Migration
  def self.up
  	drop_table :addressables
  	add_column :addresses, :customer_id, :integer
  	add_column :addresses, :is_default_billing, :boolean
  	add_column :addresses, :is_default_shipping, :boolean
  end

  def self.down
	

  end
end
