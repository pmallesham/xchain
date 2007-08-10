class LoadDatabase < ActiveRecord::Migration
  def self.up
  
  	create_table "addresses", :force => true do |t|
  	  t.column "address", :text 
  	  t.column "city", :string
  	  t.column "postcode", :string
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
      t.column "billing_address",          :text
      t.column "billing_city",                :string
      t.column "billing_postcode",          :string
      t.column "shipping_address",         :text
      t.column "shipping_address",         :string,   :limit => 50
      t.column "shipping_city",              :string,   :limit => 20
      t.column "shipping_postcode", :string,   :limit => 10,                                 :default => "",  :null => false
      t.column "notes",                      :text
      t.column "payment_method_id",          :integer
      t.column "payment_is_received",        :integer
      t.column "payment_received_date",      :datetime
      t.column "total_amount_payable",       :decimal,                 :precision => 11, :scale => 2
      t.column "total_amount_pay_online",    :decimal,                 :precision => 11, :scale => 2, :default => 0.0, :null => false
      t.column "shipping_amount",            :decimal,                 :precision => 11, :scale => 2
      t.column "shipping_weight",            :decimal,                 :precision => 11, :scale => 2
      t.column "shipping_method_id",         :integer
      t.column "airway_bill_number",         :string,   :limit => 150
      t.column "tracking_response",          :string,   :limit => 150
      t.column "last_tracking_update_time",  :datetime
      t.column "shipping_contact",           :string,   :limit => 50
      t.column "shipping_phone",             :string,   :limit => 50
      t.column "tax_type",                   :string,   :limit => 20
      t.column "tax_amount",                 :decimal,                 :precision => 11, :scale => 2
      t.column "sub_total",                 :decimal,                 :precision => 11, :scale => 2
      t.column "invoice_text",               :text,                                                   :default => "",  :null => false
      t.column "invoice_pdf",                :binary,                                                 :default => "",  :null => false
      t.column "weight",                     :float,    :limit => 6,                                  :default => 0.0, :null => false
      t.column "shipping_country_id",        :integer,  :limit => 3,                                  :default => 0,   :null => false
      t.column "billing_address_2",          :string
      t.column "previous_order_status_id",   :integer
    end

    add_index "orders", ["id"], :name => "order_id", :unique => true

    create_table "payment_methods", :force => true do |t|
      t.column "name",      :string,  :limit => 60
    end
    
    create_table "payment_terms", :force => true do |t|
      t.column "terms_text", :string, :limit => 100, :default => "", :null => false
    end

    create_table "price_types", :force => true do |t|
      t.column "code",                   :string,  :limit => 45,  :default => "",  :null => false
      t.column "is_discountable",        :integer, :limit => 1,   :default => 1,   :null => false
      t.column "title",                  :string,  :limit => 45,  :default => "",  :null => false
      t.column "invoice_line_1",         :string,  :limit => 200, :default => "",  :null => false
      t.column "invoice_line_2",         :string,  :limit => 200, :default => "",  :null => false
      t.column "invoice_line_3",         :string,  :limit => 200, :default => "",  :null => false
      t.column "shipping_exchange_rate", :float,   :limit => 10,  :default => 1.0, :null => false
      t.column "symbol",                 :string,  :limit => 10,  :default => "",  :null => false
      t.column "dollar_sign",            :string,  :limit => 10,  :default => "$"
    end

    create_table "pricing", :force => true do |t|
      t.column "product_id",    :integer, :limit => 10,                               :default => 0, :null => false
      t.column "price_type_id", :integer, :limit => 10,                               :default => 0, :null => false
      t.column "price",         :decimal,               :precision => 5, :scale => 2
    end

    create_table "products", :force => true do |t|
      t.column "code",                    :string,  :limit => 10
      t.column "title",                   :string,  :limit => 100
      t.column "sell_price",              :decimal,                :precision => 5, :scale => 2
      t.column "visible",                 :integer, :limit => 1,                                 :default => 1
      t.column "order_min_quantity",      :integer
      t.column "qty_per_box",             :integer
      t.column "shipping_weight_per_box", :float,   :limit => 15
      t.column "commission",              :integer, :limit => 2,                                 :default => 1, :null => false
    end

    create_table "role", :force => true do |t|
      t.column "name",                         :string,  :limit => 30, :default => "0", :null => false
      t.column "can_view_orders",              :integer, :limit => 1,  :default => 0,   :null => false
      t.column "can_update_users",             :integer, :limit => 1,  :default => 0,   :null => false
      t.column "can_change_status",            :integer, :limit => 1,  :default => 0
      t.column "must_follow_status_flow",      :integer, :limit => 1,  :default => 0,   :null => false
      t.column "can_view_customers",           :integer, :limit => 1,  :default => 0
      t.column "can_view_agents",              :integer, :limit => 1,  :default => 0
      t.column "can_create_orders",            :integer, :limit => 1,  :default => 0
      t.column "can_link_customers_to_agents", :integer, :limit => 1,  :default => 0
      t.column "can_create_customers",         :integer, :limit => 1,  :default => 0
      t.column "can_create_agents",            :integer, :limit => 1,  :default => 0,   :null => false
    end

    create_table "sessions", :force => true do |t|
      t.column "session_id", :string
      t.column "data",       :text
      t.column "updated_at", :datetime
    end

    add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
    add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

    create_table "shipping_method", :force => true do |t|
      t.column "name",               :string,  :limit => 50
      t.column "status_class_name",  :string,  :limit => 20
      t.column "notification_email", :string,  :limit => 30
    end

    create_table "shipping_weight_zone_matrix", :force => true do |t|
      t.column "zone_id",        :string,  :limit => 11,                               :default => "", :null => false
      t.column "weight_bracket", :float,   :limit => 5
      t.column "rate",           :decimal,               :precision => 5, :scale => 2
    end

    create_table "shipping_zones",  :force => true do |t|
      t.column "zone_code", :string,  :limit => 20
      t.column "name",      :string,  :limit => 50
    end


    create_table "users", :force => true do |t|
      t.column "login",                     :string
      t.column "email",                     :string
      t.column "crypted_password",          :string,   :limit => 100
      t.column "salt",                      :string,   :limit => 40
      t.column "created_at",                :datetime
      t.column "updated_at",                :datetime
      t.column "remember_token",            :string
      t.column "remember_token_expires_at", :datetime
    end

    
  end

  def self.down
  end
end
