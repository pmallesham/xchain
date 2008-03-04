class AddShippingMethods < ActiveRecord::Migration
  def self.up
    create_table "shipping_methods", :force => true do |t|
      t.string :name,               :limit => 50
      t.boolean :ups_code,          :limit => 10
      t.boolean :office_calculated,  :default => false
      t.timestamps
    end
    ShippingMethod.create(:name => 'UPS SCS', :ups_code => 65, :office_calculated => false)
    ShippingMethod.create(:name => 'Sea freight', :office_calculated => true)
    ShippingMethod.create(:name => 'Customer freighted', :office_calculated => true)
  end

  def self.down
  end
end
