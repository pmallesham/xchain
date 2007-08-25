class CartLineItemsController < ApplicationController
  # GET /cart_line_items
  # GET /cart_line_items.xml
  def index
    @cart_line_items = CartLineItem.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @cart_line_items.to_xml }
    end
  end

  # GET /cart_line_items/1
  # GET /cart_line_items/1.xml
  def show
    @cart_line_item = CartLineItem.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @cart_line_item.to_xml }
    end
  end

  # GET /cart_line_items/new
  def new
    @cart_line_item = CartLineItem.new
  end

  # GET /cart_line_items/1;edit
  def edit
    @cart_line_item = CartLineItem.find(params[:id])
  end

  # POST /cart_line_items
  # POST /cart_line_items.xml
  def create
    @cart_line_item = CartLineItem.new(params[:cart_line_item])

    respond_to do |format|
      if @cart_line_item.save
        flash[:notice] = 'CartLineItem was successfully created.'
        format.html { redirect_to cart_line_item_url(@cart_line_item) }
        format.xml  { head :created, :location => cart_line_item_url(@cart_line_item) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cart_line_item.errors.to_xml }
      end
    end
  end

  # PUT /cart_line_items/1
  # PUT /cart_line_items/1.xml
  def update
    @cart_line_item = CartLineItem.find(params[:id])

    respond_to do |format|
      if @cart_line_item.update_attributes(params[:cart_line_item])
        flash[:notice] = 'CartLineItem was successfully updated.'
        format.html { redirect_to cart_line_item_url(@cart_line_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cart_line_item.errors.to_xml }
      end
    end
  end

  # DELETE /cart_line_items/1
  # DELETE /cart_line_items/1.xml
  def destroy
    @cart_line_item = CartLineItem.find(params[:id])
    @cart_line_item.destroy

    respond_to do |format|
      format.html { redirect_to cart_line_items_url }
      format.xml  { head :ok }
    end
  end
end
