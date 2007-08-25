class AddressesController < ApplicationController
  before_filter :find_customer
  
  # GET /addresses
  # GET /addresses.xml
  def index
    @addresses = Address.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @addresses.to_xml }
    end
  end

  # GET /addresses/1
  # GET /addresses/1.xml
  def show
    @address = @customer.addresses.find(params[:id])

    respond_to do |format|
      format.html do
        render :update do |page|
          page.replace_html "ab#{@address.id}", "Hello World"
        end
      end
      format.xml  { render :xml => @address.to_xml }
    end
  end

  # GET /addresses/new
  def new
    @address = Address.new
    render :update do |page|
      page['newAddress'].hide
	    page.insert_html :bottom, "addressBox", :partial => 'new', :locals => { :address => @address, :customer => @customer }
    end
  end

  # GET /addresses/1;edit
  def edit
    @address = @customer.addresses.find(params[:id])
    render :update do |page|
      page.replace "ab#{@address.id}", :partial => 'form', :locals => { :customer => @customer, :address => @address }
    end
  end

  # POST /addresses
  # POST /addresses.xml
  def create
    @address = @customer.addresses.create(params[:address])
    if @address.save
	   render :update do |page|
	     page['newAddress'].show
	     page.replace "newAddressForm", :partial => 'show', :locals => { :address => @address, :customer => @customer }
       end
    else
	   render :update do |page|	     
	     page.replace "newAddressForm", :partial => 'new', :locals => { :address => @address, :customer => @customer }
       end
    end
  end

  # PUT /addresses/1
  # PUT /addresses/1.xml
  def update
    @address = Address.find(params[:id])
    if @address.update_attributes(params[:address])
	   render :update do |page|
	     page.replace "ab#{@address.id}", :partial => 'show', :locals => { :address => @address, :customer => @customer }
       end
    else
	   render :update do |page|
	     page.replace "ab#{@address.id}", :partial => 'form', :locals => { :address => @address, :customer => @customer }
       end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.xml
  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    respond_to do |format|
      format.html { redirect_to addresses_url }
      format.xml  { head :ok }
    end
  end
  
  protected 
  def find_customer
    @customer = Customer.find(params[:customer_id])
  end
  
end
