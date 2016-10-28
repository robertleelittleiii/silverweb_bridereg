class BridesController < ApplicationController
  before_action :set_bride, only: [:show, :edit, :update, :destroy, :update_gift_list, :render_gift_section, :render_gift_list]

  # GET /brides
  def index
    @brides = Bride.all
  end

  # GET /brides/1
  def show
  end

  # GET /brides/new
  def new
    @bride = Bride.new
  end

  # GET /brides/1/edit
  def edit
  end

  # POST /brides
  def create
    @bride = Bride.new(bride_params)

    if @bride.save
      redirect_to @bride, notice: 'Bride was successfully created.'
    else
      render :new
    end
  end
  
  
  # POST /brides
   
  def create_empty_record
    @bride = Bride.new
    
    @bride.user = User.new
    @bride.user.name = "User_" + Time.now.to_i.to_s + "@someaddress.com"
    @bride.user.password = "password"
    @bride.user.password_confirmation = "password"
 
    role = Role.find_by_name("Bride")
    @bride.user.roles << role
    
    @bride.user.user_attribute = UserAttribute.new
    @bride.user.user_attribute.first_name = "First"
    @bride.user.user_attribute.last_name = "Last"
    @bride.user.user_attribute.save
    
    @bride.user.save
    
    @bride.save
    
    redirect_to @bride, notice: 'Bride was successfully created with password: "password"'
  end


  # PATCH/PUT /brides/1
  #  def update
  #    if @bride.update(bride_params)
  #      redirect_to @bride, notice: 'Bride was successfully updated.'
  #    else
  #      render :edit
  #    end
  #  end

  def update
    respond_to do |format|
      if @bride.update(bride_params)
        format.html { redirect_to(:action =>"edit", :notice => 'Bride was successfully updated.') }
        format.json { render :json=> {:notice => 'Bride was successfully updated.'} }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @bride.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /coupons/1
  # DELETE /coupons/1.json
  def destroy
    @bride.destroy

    respond_to do |format|
      format.html { redirect_to brides_url, notice: 'Bride was successfully deleted.' }
      format.json { head :ok }
    end
  end
  
    

  def update_gift_list
    @product = Product.find(params[:product_id])

    check_for_duplicate = GiftRegistry.where(:product_id=>params[:product_id]).where(:bride_id=>params[:id])
    if check_for_duplicate.length == 0 then
      @gift_product = GiftRegistry.new
      @gift_product.product_id=params[:product_id]
      @gift_product.quantity_reserved = 0
      @gift_product.quantity_requested = 0
      @gift_product.position = 999
      @gift_product.save
      @bride.gift_registries << @gift_product
      @bride.save
      render :json=>{:success=>true, :alert=>"Gift '" + @gift_product.product.product_name.to_s + "' added to this bride."} 
    else
      render :json=>{:success=>false, :alert=>"Can not add duplicate gift."} 

    end
    
  end
  
  def render_gift_section
  
    render(partial: "gift_section")
    
  end
  
    def render_gift_list
    @gifts = @bride.gift_registries
    
    render(partial: "gift_list")
   
  end
    
  def update_gift_order
    params[:gift].each_with_index do |id, position|
      #     related_product = ProductRelatedProduct.find(id)
      #     related_product.position = position
      #     related_product.save
      #   Image.update(id, :position => position)
      GiftRegistry.reorder(id,position)
    end
    render nothing: true

  end

  
  
  def bride_table
    @objects = current_objects(params)
    @total_objects = total_objects(params)
    render layout: false
  end
  
    
  
  private
  
  
  def current_objects(params={})
    current_page = (params[:start].to_i/params[:length].to_i rescue 0)+1
    @current_objects = Bride.eager_load(:user).eager_load(:user=>:user_attribute).page(current_page).per(params[:length]). 
      order("#{datatable_columns(params[:order]["0"][:column])} #{params[:order]["0"][:dir] || "DESC"}").
      where(conditions)
  end
    

  def total_objects(params={})
    @total_objects = Bride.count
  end

  def datatable_columns(column_id)
    case column_id.to_i
    when 0
      return "brides.id"
    when 1
      return "user_attributes.first_name"
    else
      return "brides.wedding_date"
    end
  end

  def conditions
    conditions = []
    conditions << "( `user_attributes`.`first_name` LIKE '%#{params[:search][:value]}%') OR (`user_attributes`.`last_name` LIKE '%#{params[:search][:value]}%') OR ( `brides`.`wedding_date` LIKE '%#{params[:search][:value]}%')" if (!params[:search][:value].blank?)
    return conditions.join(" AND ")
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_bride
    @bride = Bride.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def bride_params
    params.require(:bride).permit(:id, :user_id, :wedding_date, :groom_full_name)
  end
end
