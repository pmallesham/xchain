class AddBillingCountryId < ActiveRecord::Migration
  def self.up
    add_column :orders, :billing_country_id, :integer
  end

  def self.down
    remove_column :orders, :billing_country_id
  end
end
