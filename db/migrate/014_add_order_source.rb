class AddOrderSource < ActiveRecord::Migration
  def self.up
    add_column :orders, :source_id, :integer
  end

  def self.down
    remove_column :orders, :source_id
  end
end
