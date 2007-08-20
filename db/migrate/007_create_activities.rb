class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
    	t.column :activity_type_id, :integer
    	t.column :detail, :string
    	t.column :created_at, :datetime	
    end
  end

  def self.down
    drop_table :activities
  end
end
