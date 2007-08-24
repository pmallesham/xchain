class CustomersController < ApplicationController
  # GET /customers
  # GET /customers.xml
  def index
    @customers = Customer.find(:all, :include => [:country, :status])

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @customers.to_xml }
    end
  end

  # GET /customers/1
  # GET /customers/1.xml
  def show
    @customer = Customer.find(params[:id], :include => [{ :addressables => :address }, :country ])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @customer.to_xml }
    end
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1;edit
  def edit
    @customer = Customer.find(params[:id])
  end

  # POST /customers
  # POST /customers.xml
  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        flash[:notice] = 'Customer was successfully created.'
        format.html { redirect_to customer_url(@customer) }
        format.xml  { head :created, :location => customer_url(@customer) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors.to_xml }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    @customer = Customer.find(params[:id])
    

    respond_to do |format|
              if @customer.update_attributes(params[:customer])
                flash[:notice] = 'Customer was successfully updated.'
                format.html { redirect_to customer_url(@customer) }
                format.xml  { head :ok }
              else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @customer.errors.to_xml }
              end
   end
  end

  # DELETE /customers/1
  # DELETE /customers/1.xml
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url }
      format.xml  { head :ok }
    end
  end
end
