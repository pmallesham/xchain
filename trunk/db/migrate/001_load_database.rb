class LoadDatabase < ActiveRecord::Migration
  def self.up
  
  	create_table "addresses", :force => true do |t|
  	  t.column "address", :text 
  	  t.column "city", :string
  	  t.column "post_code", :string
  	  t.column "state", :string
  	  t.column "country_id", :integer
  	  t.column "phone", :string
  	  t.column "fax", :string
  	  t.column "contact_person", :string
  	end 
  	
  	create_table "addressables", :force => true do |t|
  	  t.column "address_id", :integer
  	  t.column "customer_id", :integer
  	  t.column "address_type", :integer
  	  t.column "is_default", :boolean
  	end
    
    create_table "cc_gateway_logs", :force => true do |t|
      t.column "when_logged", :integer, :limit => 10, :default => 0,  :null => false
      t.column "order_id",    :integer, :limit => 10, :default => 0,  :null => false
      t.column "gateway_ref", :string,  :limit => 20, :default => "", :null => false
      t.column "success",     :integer, :limit => 3,  :default => 0,  :null => false
      t.column "auth_code",   :string,  :limit => 10
    end

    create_table "countries", :force => true do |t|
      t.column "name",          :string,  :limit => 100
      t.column "zone_id",       :integer
      t.column "iso_code",      :string,  :limit => 2,   :default => "", :null => false
      t.column "currency_code", :string,  :limit => 3
    end

    add_index "countries", ["id"], :name => "country_id", :unique => true

    create_table "customer_agent_link", :id => false, :force => true do |t|
      t.column "customer_id",       :integer,  :default => 0, :null => false
      t.column "agent_customer_id", :integer,  :default => 0, :null => false
      t.column "since",             :datetime
    end

    create_table "customer_statuses", :force => true do |t|
      t.column "name",       :string,  :limit => 50
      t.column "sort_order", :integer
    end

    create_table "customers", :force => true do |t|
      t.column "status_id",          :integer,                :default => 0
      t.column "is_agent",           :integer
      t.column "name",               :string,  :limit => 100
      t.column "alternate_name",     :string,  :limit => 100
      t.column "phone",              :string,  :limit => 79
      t.column "fax",                :integer, :limit => 30
      t.column "email",              :string,  :limit => 100
      t.column "country_id",         :integer
      t.column "website_url",        :string,  :limit => 60
      t.column "price_type_id",      :integer,                :default => 1,  :null => false
      t.column "payment_term_id",    :integer,                :default => 1,  :null => false
      t.column "billing_address_2",  :string
    end

    add_index "customers", ["id"], :name => "customer_id", :unique => true

    create_table "failed_ups_requests", :id => false, :force => true do |t|
      t.column "failure_id",   :integer,                                                :null => false
      t.column "order_id",     :integer
      t.column "context",      :string,   :limit => 200
      t.column "weight",       :decimal,                 :precision => 11, :scale => 5
      t.column "toPostCode",   :string,   :limit => 200
      t.column "toCity",       :string,   :limit => 200
      t.column "failure_time", :datetime
      t.column "toCountry",    :string,   :limit => 250
    end

    add_index "failed_ups_requests", ["failure_id"], :name => "failure_id", :unique => true

    create_table "log", :force => true do |t|
      t.column "logtime",  :timestamp,                                :null => false
      t.column "ident",    :string,    :limit => 16,  :default => "", :null => false
      t.column "priority", :integer,                  :default => 0,  :null => false
      t.column "message",  :string,    :limit => 200
    end

    create_table "log_id_seq", :force => true do |t|
    end

    create_table "order_lines", :force => true do |t|
      t.column "order_id",         :integer
      t.column "product_id",       :integer
      t.column "description",      :string,  :limit => 200
      t.column "qty_ordered",      :integer
      t.column "price_as_ordered", :decimal,                :precision => 7, :scale => 2
      t.column "discount_applied", :decimal,                :precision => 5, :scale => 2
    end

    add_index "order_lines", ["id"], :name => "order_line_id", :unique => true

    create_table "order_payment_history", :id => false, :force => true do |t|
      t.column "order_id",           :integer
      t.column "payment_id",         :integer
      t.column "payment_number",     :integer
      t.column "amount",             :integer
      t.column "transaction_status", :integer
    end

    create_table "order_status_histories", :force => true do |t|
      t.column "order_id",        :integer
      t.column "order_status_id", :integer
      t.column "created_at",      :datetime
      t.column "by_user_id",      :integer
      t.column "comment",         :string
    end

    add_index "order_status_histories", ["id"], :name => "order_status_history_id", :unique => true

    create_table "order_statuses", :force => true do |t|
      t.column "name",                 :string,  :limit => 50
      t.column "sort_order",           :integer
      t.column "flow_next",            :string,  :limit => 20
      t.column "notify_customer",      :integer,               :default => 0
      t.column "notify_office",        :integer,               :default => 0
      t.column "notify_manufacturing", :integer,               :default => 0
      t.column "notify_shipping",      :integer,               :default => 0
      t.column "notification_message", :text
    end

    create_table "orders", :force => true do |t|
      t.column "purchase_order_number",      :string,   :limit => 100
      t.column "order_status_id",            :integer
      t.column "created_by_id",              :integer
      t.column "created_at",                 :datetime
      t.column "customer_id",                :integer
      t.column "price_type_id",              :integer,                                                :default => 1,   :null => false
      t.column "billing_address_1",          :text
      t.column "shipping_address_1",         :text
      t.column "shipping_address_2",         :string,   :limit => 50
      t.column "shipping_city",              :string,   :limit => 20
      t.column "shipping_postcode_at_order", :string,   :limit => 10,                                 :default => "",  :null => false
      t.column "notes",                      :text
      t.column "payment_method_id",          :integer
      t.column "payment_is_received",        :integer
      t.column "payment_received_date",      :datetime
      t.column "total_amount_payable",       :decimal,                 :precision => 11, :scale => 2
      t.column "total_amount_pay_online",    :decimal,                 :precision => 11, :scale => 2, :default => 0.0, :null => false
      t.column "shipping_amount",            :decimal,                 :precision => 11, :scale => 2
      t.column "shipping_method_id",         :integer
      t.column "airway_bill_number",         :string,   :limit => 150
      t.column "tracking_response",          :string,   :limit => 150
      t.column "last_tracking_update_time",  :datetime
      t.column "shipping_contact",           :string,   :limit => 50
      t.column "shipping_phone",             :string,   :limit => 50
      t.column "tax_type",                   :string,   :limit => 20
      t.column "tax_amount",                 :decimal,                 :precision => 11, :scale => 2
      t.column "invoice_text",               :text,                                                   :default => "",  :null => false
      t.column "invoice_pdf",                :binary,                                                 :default => "",  :null => false
      t.column "weight",                     :float,    :limit => 6,                                  :default => 0.0, :null => false
      t.column "shipping_country_id",        :integer,  :limit => 3,                                  :default => 0,   :null => false
      t.column "billing_address_2",          :string
      t.column "previous_order_status_id",   :integer
    end

    add_index "orders", ["id"], :name => "order_id", :unique => true

    create_table "payment_methods", :id => false, :force => true do |t|
      t.column "method_id", :integer,               :default => 0, :null => false
      t.column "name",      :string,  :limit => 60
    end
  end

  def self.down
  end
end
