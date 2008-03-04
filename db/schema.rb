# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 16) do

  create_table "activities", :force => true do |t|
    t.integer  "activity_type_id"
    t.string   "detail"
    t.datetime "created_at"
  end

  create_table "activity_types", :force => true do |t|
    t.string "name"
    t.string "icon_name"
  end

  create_table "addresses", :force => true do |t|
    t.text    "address"
    t.string  "city"
    t.string  "postcode"
    t.string  "state"
    t.integer "country_id"
    t.string  "phone"
    t.string  "fax"
    t.string  "contact_person"
    t.integer "customer_id"
    t.boolean "is_default_billing"
    t.boolean "is_default_shipping"
  end

  create_table "cart_line_items", :force => true do |t|
    t.integer "cart_id"
    t.integer "product_id"
    t.integer "qty"
  end

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.string   "session_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "position"
    t.string   "landing_page_image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_product_links", :force => true do |t|
    t.integer "product_id"
    t.integer "category_id"
  end

  create_table "cc_gateway_logs", :force => true do |t|
    t.integer "when_logged", :limit => 10, :default => 0,  :null => false
    t.integer "order_id",    :limit => 10, :default => 0,  :null => false
    t.string  "gateway_ref", :limit => 20, :default => "", :null => false
    t.integer "success",     :limit => 3,  :default => 0,  :null => false
    t.string  "auth_code",   :limit => 10
  end

  create_table "countries", :force => true do |t|
    t.string  "name",          :limit => 100
    t.integer "zone_id"
    t.string  "iso_code",      :limit => 2,   :default => "", :null => false
    t.string  "currency_code", :limit => 3
  end

  add_index "countries", ["id"], :name => "country_id", :unique => true

  create_table "customer_agent_link", :id => false, :force => true do |t|
    t.integer  "customer_id",       :default => 0, :null => false
    t.integer  "agent_customer_id", :default => 0, :null => false
    t.datetime "since"
  end

  create_table "customer_statuses", :force => true do |t|
    t.string  "name",       :limit => 50
    t.integer "sort_order"
  end

  create_table "customers", :force => true do |t|
    t.integer "status_id",                        :default => 0
    t.integer "is_agent"
    t.string  "name",              :limit => 100
    t.string  "alternate_name",    :limit => 100
    t.string  "phone",             :limit => 79
    t.integer "fax",               :limit => 30
    t.string  "email",             :limit => 100
    t.integer "country_id"
    t.string  "website_url",       :limit => 60
    t.integer "price_type_id",                    :default => 1, :null => false
    t.integer "payment_term_id",                  :default => 1, :null => false
    t.string  "billing_address_2"
    t.string  "type"
    t.text    "notes"
  end

  add_index "customers", ["id"], :name => "customer_id", :unique => true

  create_table "discount_tables", :force => true do |t|
    t.integer "qty"
    t.float   "discount_applied"
    t.integer "discount_id"
  end

  create_table "discounts", :force => true do |t|
    t.string "rule_name"
  end

  create_table "failed_ups_requests", :primary_key => "failure_id", :force => true do |t|
    t.integer  "order_id"
    t.string   "context",      :limit => 200
    t.decimal  "weight",                      :precision => 11, :scale => 5
    t.string   "toPostCode",   :limit => 200
    t.string   "toCity",       :limit => 200
    t.datetime "failure_time"
    t.string   "toCountry",    :limit => 250
  end

  add_index "failed_ups_requests", ["failure_id"], :name => "failure_id", :unique => true

  create_table "log", :force => true do |t|
    t.datetime "logtime",                                 :null => false
    t.string   "ident",    :limit => 16,  :default => "", :null => false
    t.integer  "priority",                :default => 0,  :null => false
    t.string   "message",  :limit => 200
  end

  create_table "log_id_seq", :force => true do |t|
  end

  create_table "order_lines", :force => true do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.string  "description",      :limit => 200
    t.integer "qty_ordered"
    t.decimal "price_as_ordered",                :precision => 7, :scale => 2
    t.decimal "discount_applied",                :precision => 5, :scale => 2
  end

  add_index "order_lines", ["id"], :name => "order_line_id", :unique => true

  create_table "order_payment_history", :id => false, :force => true do |t|
    t.integer "order_id"
    t.integer "payment_id"
    t.integer "payment_number"
    t.integer "amount"
    t.integer "transaction_status"
  end

  create_table "order_status_histories", :force => true do |t|
    t.integer  "order_id"
    t.integer  "order_status_id"
    t.datetime "created_at"
    t.integer  "by_user_id"
    t.string   "comment"
  end

  add_index "order_status_histories", ["id"], :name => "order_status_history_id", :unique => true

  create_table "order_statuses", :force => true do |t|
    t.string  "name",                 :limit => 50
    t.integer "sort_order"
    t.string  "flow_next",            :limit => 20
    t.integer "notify_customer",                    :default => 0
    t.integer "notify_office",                      :default => 0
    t.integer "notify_manufacturing",               :default => 0
    t.integer "notify_shipping",                    :default => 0
    t.text    "notification_message"
    t.integer "orders_count"
  end

  create_table "orders", :force => true do |t|
    t.string   "purchase_order_number",     :limit => 100
    t.integer  "order_status_id"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.integer  "customer_id"
    t.integer  "price_type_id",                                                           :default => 1,   :null => false
    t.text     "billing_address"
    t.string   "billing_city"
    t.string   "billing_postcode"
    t.text     "shipping_address"
    t.string   "shipping_city",             :limit => 20
    t.string   "shipping_postcode",         :limit => 10,                                 :default => "",  :null => false
    t.text     "notes"
    t.integer  "payment_method_id"
    t.integer  "payment_is_received"
    t.datetime "payment_received_date"
    t.float    "total_amount_payable"
    t.decimal  "total_amount_pay_online",                  :precision => 11, :scale => 2, :default => 0.0, :null => false
    t.decimal  "shipping_amount",                          :precision => 11, :scale => 2
    t.decimal  "shipping_weight",                          :precision => 11, :scale => 2
    t.integer  "shipping_method_id"
    t.string   "airway_bill_number",        :limit => 150
    t.string   "tracking_response",         :limit => 150
    t.datetime "last_tracking_update_time"
    t.string   "shipping_contact",          :limit => 50
    t.string   "shipping_phone",            :limit => 50
    t.string   "tax_type",                  :limit => 20
    t.float    "tax_amount"
    t.float    "sub_total"
    t.text     "invoice_text"
    t.binary   "invoice_pdf"
    t.float    "weight",                                                                  :default => 0.0, :null => false
    t.integer  "shipping_country_id",       :limit => 3,                                  :default => 0,   :null => false
    t.string   "billing_address_2"
    t.integer  "previous_order_status_id"
    t.integer  "billing_country_id"
    t.integer  "payment_term_id"
    t.integer  "source_id"
  end

  add_index "orders", ["id"], :name => "order_id", :unique => true

  create_table "payment_methods", :force => true do |t|
    t.string "name", :limit => 60
  end

  create_table "payment_terms", :force => true do |t|
    t.string "terms_text", :limit => 100, :default => "", :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id"
    t.float    "amount"
    t.integer  "method"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_types", :force => true do |t|
    t.string  "code",                   :limit => 45,  :default => "",  :null => false
    t.integer "is_discountable",        :limit => 1,   :default => 1,   :null => false
    t.string  "title",                  :limit => 45,  :default => "",  :null => false
    t.string  "invoice_line_1",         :limit => 200, :default => "",  :null => false
    t.string  "invoice_line_2",         :limit => 200, :default => "",  :null => false
    t.string  "invoice_line_3",         :limit => 200, :default => "",  :null => false
    t.float   "shipping_exchange_rate",                :default => 1.0, :null => false
    t.string  "symbol",                 :limit => 10,  :default => "",  :null => false
    t.string  "dollar_sign",            :limit => 10,  :default => "$"
  end

  create_table "pricing", :force => true do |t|
    t.integer "product_id",    :limit => 10, :default => 0, :null => false
    t.integer "price_type_id", :limit => 10, :default => 0, :null => false
    t.float   "price"
    t.integer "discount_id"
  end

  create_table "products", :force => true do |t|
    t.string  "code",                    :limit => 10
    t.string  "title",                   :limit => 100
    t.decimal "sell_price",                             :precision => 5, :scale => 2
    t.integer "visible",                 :limit => 1,                                 :default => 1
    t.integer "order_min_quantity"
    t.integer "qty_per_box"
    t.float   "shipping_weight_per_box"
    t.integer "commission",              :limit => 2,                                 :default => 1, :null => false
    t.text    "description"
  end

  create_table "representations", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "agent_id"
    t.datetime "created_at"
  end

  create_table "role", :force => true do |t|
    t.string  "name",                         :limit => 30, :default => "0", :null => false
    t.integer "can_view_orders",              :limit => 1,  :default => 0,   :null => false
    t.integer "can_update_users",             :limit => 1,  :default => 0,   :null => false
    t.integer "can_change_status",            :limit => 1,  :default => 0
    t.integer "must_follow_status_flow",      :limit => 1,  :default => 0,   :null => false
    t.integer "can_view_customers",           :limit => 1,  :default => 0
    t.integer "can_view_agents",              :limit => 1,  :default => 0
    t.integer "can_create_orders",            :limit => 1,  :default => 0
    t.integer "can_link_customers_to_agents", :limit => 1,  :default => 0
    t.integer "can_create_customers",         :limit => 1,  :default => 0
    t.integer "can_create_agents",            :limit => 1,  :default => 0,   :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shipping_method", :force => true do |t|
    t.string "name",               :limit => 50
    t.string "status_class_name",  :limit => 20
    t.string "notification_email", :limit => 30
  end

  create_table "shipping_methods", :force => true do |t|
    t.string   "name",              :limit => 50
    t.integer  "ups_code",          :limit => 10
    t.boolean  "office_calculated",               :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipping_weight_zone_matrix", :force => true do |t|
    t.string  "zone_id",        :limit => 11,                               :default => "", :null => false
    t.float   "weight_bracket"
    t.decimal "rate",                         :precision => 5, :scale => 2
  end

  create_table "shipping_zones", :force => true do |t|
    t.string "zone_code", :limit => 20
    t.string "name",      :limit => 50
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 100
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "customer_id"
  end

end
