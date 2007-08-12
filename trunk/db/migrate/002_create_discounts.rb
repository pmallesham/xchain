class CreateDiscounts < ActiveRecord::Migration
  def self.up
    create_table :discounts do |t|
      t.column 'rule_name', :string
    end
    add_column :pricing, :discount_id, :integer
  end

  def self.down
    drop_table :discounts
    remove_column :pricing, :discount_id
  end
end
