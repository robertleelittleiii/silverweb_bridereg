class GiftRegistriesController < ApplicationController
  before_action :set_gift_registry, only: [:show, :edit, :update, :destroy]

  # GET /gift_registries
  def index
    @gift_registries = GiftRegistry.all
  end

  # GET /gift_registries/1
  def show
  end

  # GET /gift_registries/new
  def new
    @gift_registry = GiftRegistry.new
  end

  # GET /gift_registries/1/edit
  def edit
  end

  # POST /gift_registries
  def create
    @gift_registry = GiftRegistry.new(gift_registry_params)

    if @gift_registry.save
    redirect_to @gift_registry, notice: 'Gift registry was successfully created.'
  else
    render :new
  end
end
  
def create_empty_record
  @gift_registry = GiftRegistry.new()

  @gift_registry.bride_id = params[:bride_id]
  @gift_registry.quantity_reserved = 0
  @gift_registry.quantity_requested = 0
  @gift_registry.position = 999

  @gift_registry.product = Product.new
  @gift_registry.product.product_name="New Product"
  @gift_registry.product.product_description = "Edit Me."
  @gift_registry.product.unit_price = 0
  @gift_registry.product.msrp = 0
  @gift_registry.product.save
    
  if @gift_registry.save
    respond_to do |format|
      format.html {redirect_to @gift_registry, notice: 'Gift was successfully created.' }
      format.json { render :json=> {:notice => 'Gift was successfully created.'} }
    end
  end
end

# PATCH/PUT /gift_registries/1
def update
    
  respond_to do |format|
    if @gift_registry.update(gift_registry_params)
      format.html { redirect_to(:action =>"edit", :notice => 'Gift was successfully updated.') }
      format.json { render :json=> {:notice => 'Gift was successfully updated.'} }
    else
      format.html { render :action => "edit" }
      format.json  { render :json => @gift_registry.errors, :status => :unprocessable_entity }
    end
  end
    
end

# DELETE /gift_registries/1
def destroy
  @gift_registry.destroy
    
  respond_to do |format|
    format.html { redirect_to gift_registries_url, notice: 'Gift registry was successfully deleted.' }
    format.json { head :ok }
    format.js { head :ok }
  end
end
  
  
 
private
# Use callbacks to share common setup or constraints between actions.
def set_gift_registry
  @gift_registry = GiftRegistry.find(params[:id])
end

# Only allow a trusted parameter "white list" through.
def gift_registry_params
  params.require(:gift_registry).permit(:id, :bride_id, :product_id, :quantity_requested, :quantity_reserved)
end
end
