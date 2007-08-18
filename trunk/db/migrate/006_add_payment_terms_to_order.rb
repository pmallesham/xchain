class AddPaymentTermsToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :payment_term_id, :integer
  end

  def self.down
    remove_column :orders, :payment_term_id
  end
end
