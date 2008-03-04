class AddOrderCount < ActiveRecord::Migration
  def self.up
    add_column :order_statuses, :orders_count, :integer
  end

  def self.down
    remove_column :order_statuses, :orders_count
  end
end
