class CartsController < ApplicationController
  # GET /carts
  # GET /carts.xml
  def index
    @carts = Cart.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @carts.to_xml }
    end
  end

  # GET /carts/1
  # GET /carts/1.xml
  def show
    @cart = Cart.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @cart.to_xml }
    end
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1;edit
  def edit
    @cart = Cart.find(params[:id])
  end

  # POST /carts
  # POST /carts.xml
  def create
    @cart = Cart.new(params[:cart])

    respond_to do |format|
      if @cart.save
        flash[:notice] = 'Cart was successfully created.'
        format.html { redirect_to cart_url(@cart) }
        format.xml  { head :created, :location => cart_url(@cart) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cart.errors.to_xml }
      end
    end
  end

  # PUT /carts/1
  # PUT /carts/1.xml
  def update
    @cart = Cart.find(params[:id])

    respond_to do |format|
      if @cart.update_attributes(params[:cart])
        flash[:notice] = 'Cart was successfully updated.'
        format.html { redirect_to cart_url(@cart) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cart.errors.to_xml }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.xml
  def destroy
    @cart = Cart.find(params[:id])
    @cart.destroy

    respond_to do |format|
      format.html { redirect_to carts_url }
      format.xml  { head :ok }
    end
  end
end
