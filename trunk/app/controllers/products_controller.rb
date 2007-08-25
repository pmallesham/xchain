class ProductsController < ApplicationController
  before_filter :load_category_if_exists
  
  # GET /products
  # GET /products.xml
  def index
    if @category 
      @products = category.products.find(:all)
    else
      @products = Product.find(:all)
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1;edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        flash[:notice] = 'Product was successfully created.'
        format.html { redirect_to product_url(@product) }
        format.xml  { head :created, :location => product_url(@product) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors.to_xml }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to product_url(@product) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors.to_xml }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.xml  { head :ok }
    end
  end
  
  def load_category_if_exists
    @category = Category.find(params[:category_id]) if params[:category_id]
  end
end
