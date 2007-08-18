class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.column :order_id, :integer
      t.column :amount, :float
      t.column :method, :integer
      t.column :created_by_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :payments
  end
end
