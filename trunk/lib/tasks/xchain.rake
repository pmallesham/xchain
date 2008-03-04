namespace :xchain do
  namespace :test do
    desc "Load fake customers"
    task :load_customers => :environment do
      require 'Faker'
      Customer.find(:all, :conditions => "email LIKE('%XCHAIN_%')").each { |c| c.destroy }
      1..300.times do 
        c = Customer.new
        c.status_id = rand(3) + 1
        c.country_id = rand(243) + 1
        c.name = Faker::Company.name
        c.alternate_name = Faker::Company.name
        c.phone = Faker::PhoneNumber.phone_number
        c.email = "XCHAIN_"+Faker::Internet.email
        c.fax = Faker::PhoneNumber.phone_number
        c.price_type_id = rand(3) + 1
        c.payment_term_id = rand(3) + 1
        c.save
        
        c.addresses.create(:is_default_billing => 1, :address => Faker::Address.street_address , :city => 'City' , :state => Faker::Address.us_state , :postcode => Faker::Address.zip_code , :country_id => c.country_id, :phone => Faker::PhoneNumber.phone_number , :fax => Faker::PhoneNumber.phone_number )
        c.addresses.create(:is_default_shipping => 1, :address => Faker::Address.street_address , :city => 'City' , :state => Faker::Address.us_state , :postcode => Faker::Address.zip_code , :country_id => c.country_id, :phone => Faker::PhoneNumber.phone_number , :fax => Faker::PhoneNumber.phone_number )
        
      end
    end
    
    desc "Load Orders"
    task :load_orders => :environment do 
      require 'Faker'
      
      #staging stuff 
      active_customers = Customer.find(:all, :conditions => 'status_id = 1')
      products = Product.find(:all)
      tp = products.size
      order_statuses = OrderStatus.find(:all)
      os = order_statuses.size 
      
      #clear out old orders
      Order.find(:all).each { |o| o.destroy }
      
      1..2.times do 
        active_customers.each do |active_customer|
          Order.transaction do 
            o = active_customer.orders.build
            o.purchase_order_number = "XCHAIN_"+rand(100000).to_s
            o.prefill_address
            o.order_lines.build(:qty_ordered => rand(10), :product => products[rand(tp)])
            o.calculate
            o.save
            o.set_status(order_statuses[rand(os)], 'XCHAIN_TESTING')
          o.save
          end
        end 
      end
      
      #create a lot of archived and old orders
      1..2.times do 
        Customer.transaction do 
          active_customers.each do |active_customer|
            o = active_customer.orders.build
            o.purchase_order_number = "XCHAIN_"+rand(100000).to_s
            o.prefill_address
            o.order_lines.build(:qty_ordered => rand(10), :product => products[rand(tp)])
            o.calculate
            o.save
            o.set_status(OrderStatus.find(14), 'XCHAIN_TESTING')
            o.set_status(OrderStatus.find(22), 'XCHAIN_TESTING')
            o.set_status(OrderStatus.find(30), 'XCHAIN_TESTING')
            o.set_status(OrderStatus.find(40), 'XCHAIN_TESTING')
            o.set_status(OrderStatus.find(50), 'XCHAIN_TESTING')
            o.set_status(OrderStatus.find(100), 'XCHAIN_TESTING')
            o.save
          end 
        end
      end
       
      #Create 1000 orders 
    end

    desc 'Reset Price Types'
    task :reset_price_types => :environment do 
      Pricing.find(:all).each { |p| p.destroy }
      @products = Product.find(:all)
      PriceType.find(:all).each do |price_type|
        @products.each do |product|
          Pricing.create(:product => product, :price_type => price_type, :price => rand(500), :discount_id => 1)
        end
      end
    end
  end
end