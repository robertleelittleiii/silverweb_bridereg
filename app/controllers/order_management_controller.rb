class OrderManagementController < ApplicationController
  
  def update_cart_item
    @cart=Cart.get_cart("cart"+session[:session_id], session[:user_id]) rescue  Rails.cache.write("cart"+session[:session_id],{}, :expires_in => 15.minutes)
    @product = Product.find(params[:product])
    @cart_item = @cart.get_cart_items(@product).first
    
    @flash_message = ""
    @return_quantity = params[:cart_item][:quantity].to_i
    
    begin 
      @cart.update_product(@cart_item.product_detail, params[:cart_item][:quantity].to_i)
    
    rescue Exception => e
      message_json = JSON.parse(e.message)
      puts(message_json)
      @return_quantity = message_json["max_value"].to_s
      @flash_message = "Requested amount exceeded inventory, set to max available."
    end

    # @cart_item.quantity = params[:cart_item][:quantity].to_i
    puts(@cart_item.inspect)
    
    #@cart=Cart.get_cart("cart"+session[:session_id], session[:user_id]) rescue  Rails.cache.write("cart"+session[:session_id],{}, :expires_in => 15.minutes)
    #@cart_item = @cart.get_cart_item_color_size_product(@product, params[:color],params[:size])

    
    respond_to do |format|
      format.html { render :text=>@flash_message }
      format.json { render json: {:cart_item=>@return_quantity,:message=>@flash_message}}
      format.text { render json: {:cart_item=>@return_quantity,:message=>@flash_message}}
    end
  end
  
  
   def get_cart_contents 
          find_cart
          @checkout_cart = @cart
          render :partial => "build_product_item.html" , :collection => @checkout_cart.get_cart_products
        end
        
  def order_page 
    @product = Product.find(params[:product_id])
    
    @product_details = @product.product_details
    @product_colors = @product_details.group(:color).where(:sku_active=>true) || [{:size=>'N/C'}] rescue [{:size=>'N/C'}]
    @product_sizes = @product_details.select("distinct `size`, `units_in_stock`").where("`color` = '#{@product_colors[0].color}'").where(:sku_active=>true)  || [{:size=>'N/S', :units_in_stock=>"0"}] rescue [{:size=>'N/S', :units_in_stock=>"0"}]
    @product_size_array = @product_sizes.map{ |f| f.size }

    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product}
    end
  end
  
  def add_to_order
    @cart=Cart.get_cart("cart"+session[:session_id], session[:user_id])
    @flash_message = ""
    
    #@cart.add_product(product, product_detail, quantity);
     
    puts(params.inspect)
    @product = Product.find(params[:product_id])
    
    params[:color_size].each  do |color_size_item|
      color_size_split = color_size_item.first.split("_")
      product_color = color_size_split[0].gsub("2z1AaA1z2"," ").gsub("0a0", "-")
      product_size = color_size_split[1].gsub("a","-") rescue "n/a"
      puts(color_size_split.inspect)
      puts(product_color)
      puts(product_size)
      @product_detail = @product.product_details.where(size: product_size).where(color:product_color).first
      begin 
        @cart.add_product(@product, @product_detail, color_size_item.second, params[:gift_id]);
      rescue 
        @flash_message = @flash_message +  " #{product_color}:#{product_size}, "
      end
    end
    
    if !@flash_message.blank? then
      @flash_message = @flash_message + " These items amounts have been adjusted to max quantity available."
    end
    respond_to do |format|
      format.html { render :text=>@flash_message }
      format.json { render json: @product}
    end
  end
  
  def complete_order
    find_cart()
    
    @shipping_methods = [["Ground",0] , ["2 Day",1], ["Next Day",2], ["Pick Up Store",3]]
          
    if @cart.items.empty? or @cart.bride.nil? then
      redirect_to(:controller => "site", :action => "index")
   else
      #@cart.hide
      #@cart.set_shipping(@cart.calc_shipping)
      #@order = Order.new


     
    end
  end
  
    
  def find_cart
    #  @cart = (session[:cart] ||= Cart.new)
    #user =  User.find_by_id(session[:user_id])

    session[:create]=true
    
    @cart=Cart.get_cart("cart"+session[:session_id], session[:user_id]) rescue  Rails.cache.write("cart"+session[:session_id],{}, :expires_in => 15.minutes)
    
    puts("@cart in find_cart: #{@cart}")
          
    if not params[:coupon_code].blank? then
      puts("Coupon Code Found")
      @cart.coupon_code = params[:coupon_code]
      @cart.save
    end
    
    #   @cart = Cart.get_cart(session[:cart])
    #    session[:cart] = @cart.id
  end
  
  def get_product_sub_totals
    @product = Product.find(params[:product_id])
    find_cart
    
    respond_to do |format|
      format.html { render(partial: "build_order_product_summary")}
      format.json { render json: @product}
    end
    
  end

  
  
  def enter_order
    $hostfull = request.protocol + request.host_with_port

    @user = User.find_by_id(session[:user_id])
    @page_title = "order success"
    @page = Page.find_by_title (@page_title).first
    find_cart
    
    bride_id = session[:bride_id]
    
    cart_is_empty = false;
    purchase_success = false;
    error_occured = false;
    
    redirect_controller = :site
    redirect_action = :index
        
    if params[:order].blank? then
      puts("****************** New order from cart ************")
      @order=Order.new(:express_token=>params[:token])
      error_occured=true
    else
    
      puts("params[cc_expires(1i)]#{params[:order]["cc_expires(1i)"].inspect}")
      puts("params[cc_expires(2i)]#{params[:order]["cc_expires(2i)"].inspect}")
      puts("params[cc_expires(3i)]#{params[:order]["cc_expires(3i)"].inspect}")

      user =  User.find_by_id(session[:user_id])

      @cart=Cart.get_cart("cart"+session[:session_id], user.id)

      @order = Order.new(order_params)
      @order.add_line_items_from_cart(@cart, $hostfull, bride_id)
      @order.shipping_method = @cart.shipping_type
      @order.sales_tax = @cart.calc_tax 
      @order.shipping_cost = @cart.calc_shipping[@cart.shipping_type]
      @order.user = User.find_by_id(session[:user_id])
      @order.ip_address = request.remote_ip
      @order.coupon_description = @cart.coupon_description
      @order.coupon_value = @cart.coupon_value
      @order.store_wide_sale = @cart.calc_store_wide_sale
      @order.bride_id = bride_id
      puts("-=-=-=-=-=-=-=-=-=-=-=-=-=->>>> #{@order.inspect}")

      
      
      if @cart.total_price > 0 then
        if @order.save
          @order.transactions.create!(:action => "orderd", :amount => @order.price_in_cents, :response => ActiveMerchant::Billing::Response.new(true,"Order Created"))
          @order.reduce_inventory($hostfull)
            
          if  not Settings.order_notification then
            UserNotifier.order_notification(@order, @user, $hostfull).deliver
          else
            UserNotifier.order_notification_as_invoice(@order, @user, $hostfull).deliver
          end
            
          #  if there is a coupon, make a record that it was used.
          if not @cart.coupon_code.blank? then
            @coupon = Coupon.where(coupon_code: @cart.coupon_code).first
            @coupon_used = CouponUsage.create(user_id: @user.id, coupon_id: @coupon.id)
            @coupon.save
          end

          empty_cart_no_redirect
            
          redirect_controller = :orders
          redirect_action = :order_success
          puts("****************** Purchase Success  ************")
    
          purchase_success = true              # return
          # format.html {render :action => "order_success"}
         
          #  format.html { redirect_to @order, :notice=>"Order was successfully created." }
          #  format.json { render :json=>@order, :status=>:created, :location=>@order }
        else
          error_occured = true
        end
      else
        puts("****************** Cart is empty (redirect to /site/index) ************")
       
        redirect_controller = :site
        redirect_action = :index
      
        # cart_is_empty = true
      end
    end 
  
    respond_to do |format|
      if error_occured then
        puts("****************** ERROR OCCURED ************")
        puts("#{@order.errors.inspect}")
        format.html { render action: :enter_order, controller: :order_management, params: params[:order] }
        format.json { render json: @order.errors, status: :unprocessable_entry }
      else

        puts("****************** Redirct occured   ************")
        format.html { redirect_to(controller: redirect_controller, action: redirect_action, id: @order) && return}
      end
   
    end
  end

  def delete_cart_item
    find_cart
    @current_item_counter=params[:current_item]
    @current_item=@cart.items.delete_at(@current_item_counter.to_i)
    @cart.save

    respond_to do |format|
      format.json  { head :ok }
      format.html {render :nothing=>true}
    end
  end
        
  
  def order_success 
    @page_title = "order success"
    @order = Order.find(params[:id])
    @user = User.find_by_id(session[:user_id])
    @page = Page.find_by_title (@page_title).first
    @company_name = Settings.company_name
    @company_address = Settings.company_address
    @company_phone = Settings.company_phone
    @company_fax = Settings.company_fax 
  end
  
  def invoice_slip
    @page_title = "order success"

    @order = Order.find(params[:id])
    @user = User.find_by_id(session[:user_id])
    @page = Page.find_by_title (@page_title).first
    @company_name = Settings.company_name
    @company_address = Settings.company_address
    @company_phone = Settings.company_phone
    @company_fax = Settings.company_fax
    
    render partial: "invoice_report.html", layout: false
  end
  
  private 
  
  def order_params
    params[:order].permit("user_id", "credit_card_type", "credit_card_expires", "ip_address", "shipped", "shipped_date", "ship_first_name", "ship_last_name", "ship_street_1", "ship_street_2", "ship_city", "ship_state", "ship_zip", "bill_first_name", "bill_last_name", "bill_street_1", "bill_street_2", "bill_city", "bill_state", "bill_zip", "created_at", "updated_at", "shipping_cost", "sales_tax", "shipping_method", "coupon_description", "coupon_value", "store_wide_sale","cc_number", "cc_verification", "cc_expires(1i)", "cc_expires(2i)", "cc_expires(3i)", "express_token","bill_phone", "ship_phone")
  end
  
  def empty_cart_no_redirect
    find_cart
    @cart.delete
    session[:cart] = nil
    find_cart
  end
end