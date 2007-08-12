class CreateDiscountTables < ActiveRecord::Migration
  def self.up
    create_table :discount_tables do |t|
      t.column "qty", :integer
      t.column "discount_applied", :float
      t.column "discount_id", :integer
    end
  end

  def self.down
    drop_table :discount_tables
  end
end
