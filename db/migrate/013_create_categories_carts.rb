class CreateCategoriesCarts < ActiveRecord::Migration
  def self.up
    create_table :category_product_links do |t|
      t.column :product_id, :integer
      t.column :category_id, :integer
    end
    create_table :categories do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :position, :integer
      t.column :landing_page_image, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    create_table :carts do |t|
      t.column :user_id, :integer
      t.column :session_key, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    create_table :cart_line_items do |t|
      t.column :cart_id, :integer
      t.column :product_id, :integer
      t.column :qty, :integer
    end
    add_column :products, :description, :text
  end

  def self.down
    drop_table :category_product_links
    drop_table :categories
    drop_table :carts
    drop_table :cart_line_items
    remove_column :products, :description
  end
end
