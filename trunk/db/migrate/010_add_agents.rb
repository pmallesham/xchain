class AddAgents < ActiveRecord::Migration
  def self.up
  	create_table :representations do |r|
  		r.column :customer_id, :integer
  		r.column :agent_id, :integer
  		r.column :created_at, :datetime
  	end
  	add_column :customers, :type, :string
  end

  def self.down
  	drop_table :representation
  	remove_column :customers, :type
  end
end
