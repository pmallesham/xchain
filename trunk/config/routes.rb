ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
   map.connect '', :controller => "dashboard"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

    map.resources :users, :sessions, :customers
    map.resources :orders, 
                  :new => { :select_customer => :get }, 
                  :member => { :review => :get, 
                               :update_status => :post, 
                               :select_payment => :get,
                               :payment_selection => :put,
                               :awaiting_payment => :get, 
                               :pay_online => :get, 
                               :show_xml => :get }

    map.signup '/signup', :controller => 'users', :action => 'new'
    map.login  '/login', :controller => 'sessions', :action => 'new'
    map.logout '/logout', :controller => 'sessions', :action => 'destroy'

    # Allow downloading Web Service WSDL as a file with an extension
    # instead of a file named 'wsdl'
    map.connect ':controller/service.wsdl', :action => 'wsdl'



    # Install the default route as the lowest priority.
    map.connect ':controller/:action/:id'

end
