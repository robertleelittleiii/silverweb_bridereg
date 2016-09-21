module SilverwebBridereg
  module ControllerExtensions
  
    #    module MenusControllerExtensions
    #    
    #      def self.included(base)
    #        base.send(:include, InstanceMethods)
    #        # base.alias_method_chain :new, :my_module
    #      end
    #
    #      module InstanceMethods
    #        
    #        def update_checkbox_tag
    #          @menu = Menu.find(params[:id])
    #          @tag_name=params[:tag_name] || "tag_list"
    #    
    #          if @menu.send(@tag_name).include?(params[:field]) then
    #            @menu.send(@tag_name).remove(params[:field])
    #          else
    #            @menu.send(@tag_name).add(params[:field])
    #          end
    #    
    #          @menu.save
    #
    #          render(nothing: true)
    #
    #      
    #        end
    #        
    #        def render_category_div
    #          @menu=Menu.find(params[:id])
    #          render(partial: "category_div")
    #        end
    #  
    #      end
    #      
    #      
    #    end
    
    module SiteControllerExtensions
     
      def self.included(base)
        base.send(:include, InstanceMethods)
        # base.alias_method_chain :new, :my_module
      end

      module InstanceMethods
        
      
        #       before_filter :find_cart, :except => :empty_cart

        def show_my_gifts
          puts("in show my gifts...")
          @user =  User.where(:id=>session[:user_id]).includes(:user_attribute).first
          
          if !@user.nil? then
          
            @bride = @user.bride
         
            if !@bride.nil? then
           
          
              session[:bride_id] = @bride.id
          
              @page_name = "Wishlist for " + @bride.user.full_name
              @gifts_per_page = Settings.gifts_per_page.to_i || 8
        
          
              @gifts_list = @bride.gift_registries
    
              @gift_ids = @gifts_list.collect{|gift| gift.id }

              @gift_count = @gifts_list.length

              @gifts = GiftRegistry.where(:id=>@gift_ids).order("position ASC").order("created_at DESC").page(params[:page]).per(@gifts_per_page)

              @gift_first = params[:page].blank? ? "1" : (params[:page].to_i*@gifts_per_page - (@gifts_per_page-1))
    
              @gift_last = params[:page].blank? ? @gifts.length : ((params[:page].to_i*@gifts_per_page) - @gifts_per_page) + @gifts.length || @gifts.length
            end
          end
          if @user.nil? then
            redirect_to :controller=>:site, :alert=>"Please login to access your registry."
          elsif @bride.nil? then
            redirect_to :controller=>:site, :alert=>"You do not have a registry on this site.  Contact support."
          else
            respond_to do |format|
              format.html 
              format.xml  { render :xml => @gifts }
            end
          end
        
        end
        
        
        def show_gifts
          puts("in show items...")
          @bride = Bride.find(params[:id])
          # find_cart()
          @cart=Cart.get_cart("cart"+session[:session_id], session[:user_id]) rescue  Rails.cache.write("cart"+session[:session_id],{}, :expires_in => 15.minutes)
          # @cart = find_cart

          @cart.bride = @bride if !@bride.nil?
         
          session[:bride_id] = params[:id]
          
          @cart.save
          
          puts("----------- >> cart << --------------")
          puts(@cart.inspect)
          puts("----------- >> cart << --------------")

          @page_name = "Wishlist for " + @bride.user.full_name
          @gifts_per_page = Settings.gifts_per_page.to_i || 8
        
          
          @gifts_list = @bride.gift_registries
    
          @gift_ids = @gifts_list.collect{|gift| gift.id }

          @gift_count = @gifts_list.length

          @gifts = GiftRegistry.where(:id=>@gift_ids).order("position ASC").order("created_at DESC").page(params[:page]).per(@gifts_per_page)

          @gift_first = params[:page].blank? ? "1" : (params[:page].to_i*@gifts_per_page - (@gifts_per_page-1))
    
          @gift_last = params[:page].blank? ? @gifts.length : ((params[:page].to_i*@gifts_per_page) - @gifts_per_page) + @gifts.length || @gifts.length
                          
          respond_to do |format|
            format.html 
            format.xml  { render :xml => @gifts }
          end
        end
        
        def update_cart_item
          @cart=Cart.get_cart("cart"+session[:session_id], session[:user_id]) rescue  Rails.cache.write("cart"+session[:session_id],{}, :expires_in => 15.minutes)
          @product = Product.find(params[:product])
          @gift = GiftRegistry.find(params[:gift])
          
          # @cart_item = @cart.get_cart_item_color_size_product(@product, params[:color],params[:size])
    
          @flash_message = ""
          @return_quantity = params[:cart_item][:quantity].to_i
         
          #puts("cart item ---->")
          #puts(@cart_item)
          #puts(@cart_item.inspect.to_json)
          
          #puts("Cart ---->")
          #puts(@cart.inspect.to_json)
          #puts(@cart.items.inspect.to_json)
          
          if @gift.quantity_left <= 0 then
            @flash_message = "Sorry, product not available."
            params[:cart_item][:quantity] = 0
            @return_quantity = 0
          elsif @gift.quantity_left < params[:cart_item][:quantity].to_i then
            params[:cart_item][:quantity] = @gift.quantity_left
            @flash_message = "Requested amount exceeded inventory, set to max available."
            @return_quantity = @gift.quantity_left
          end
          
          #if @cart_item.nil? then
          @cart_item =  @cart.add_product(@product, @product.product_details.first, 0)
          #else          
         
          begin 
            @cart.update_product(@cart_item.product_detail, params[:cart_item][:quantity].to_i)
    
          rescue Exception => e
            message_json = JSON.parse(e.message)
            puts(message_json)
            @return_quantity = message_json["max_value"].to_s
            @flash_message = "Requested amount exceeded inventory, set to max available."
          end
          #end

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
  
        def update_session
         
          session[ params[:action_dispatch_request_session].keys[0]] =   params[:action_dispatch_request_session].values[0]

          respond_to do |format|
            format.html { render :nothing=>true }
            format.json { render :json=> {:notice => 'item was successfully updated.'} }
          end
        end
      end 
      
      def find_bride
        @bride = Bride.eager_load(:user).eager_load(:user=>:user_attribute).where("user_attributes.first_name like ?","%" + session[:bride_first_name] + "%").where("user_attributes.last_name like ?","%"+session[:bride_last_name]+"%").where("wedding_date = ?",Date.parse(session[:bride_wedding_date]).to_s(:db)) rescue {}
        @cart.delete rescue ""
        
        @cart=Cart.get_cart("cart"+session[:session_id], session[:user_id]) rescue  Rails.cache.write("cart"+session[:session_id],{}, :expires_in => 15.minutes)
        
        @cart.bride = @bride if !@bride.nil?
        @cart.save

        found = !@bride.empty?
        bride_id = @bride.first.id rescue 0
        message = found ? "Bride was found, click wishlist button to continue." : "Bride not fouund! Please double check first and last name and wedding date."
        respond_to do |format|
          format.html { render :nothing=>true }
          format.json { render :json=> {:found=>found, :bride_id => bride_id, :notice => message} }
        end
      end
      
    end
    
    
    
    #    module SiteControllerExtensions
    #     
    #      def self.included(base)
    #        base.send(:include, InstanceMethods)
    #        # base.alias_method_chain :new, :my_module
    #      end
    #
    #      module InstanceMethods
    #        
    #      
    #        #       before_filter :find_cart, :except => :empty_cart
    #
    #        def show_properties
    #          puts("in show properties...")
    #          
    #          @page = Menu.find(params[:menu_id]).page rescue nil
    #          
    #          session[:mainnav_status] = false
    #          @page_name = params["page_name"]
    #          #          session[:last_catetory] = request.env['REQUEST_URI']
    #          # @page_name = Menu.find(session[:parent_menu_id]).name rescue params[:current_page]
    #          #          @page_info = Page.where(:title => params[:page_name]).first || ""
    #          #          puts("---------the page=> #{@page_info.inspect}")
    #          #          @gifts_per_page = Settings.gifts_per_page.to_i || 8
    #          #          @category_id = params[:category_id].to_s.downcase || ""
    #          #          @department_id = params[:department_id].to_s.downcase || ""
    #          #          @category_children = params[:category_children] || false
    #          #          @get_first_submenu = params[:get_first_sub] || false
    #          #          @the_page = params[:page] || "1"
    #          #    
    #          #          @menu = Menu.where(:name=>@category_id).first 
    #          #  
    #          #          if params[:top_menu] and @get_first_submenu == "true" then
    #          #            # puts("top_menu id: #{@menu.menus[0].name}")
    #          #            session[:parent_menu_id] = @menu.id rescue 0
    #          #            @menu = @menu.menus[0]
    #          #            @category_id = @menu.name rescue "n/a"
    #          #
    #          #          end
    #          #      
    #          #@page_name=Menu.find(session[:parent_menu_id]).name rescue ""
    #          #          begin 
    #          #            if @category_children == "true" then
    #          #              @categories =  create_menu_lowest_child_list(@category_id, nil,false) + [@category_id]
    #          #              puts("categories: #{@categories.inspect} ")
    #          #              @gifts_list = Product.where(:gift_active=>true).tagged_with(@categories, :any=>true, :on=>:category).tagged_with(@department_id, :on=>:department)
    #          #
    #          #            else
    #          #              if @category_id.blank? or @department_id.blank? then
    #          #                @gifts_list = Product.where(:gift_active=>true)
    #          #              else
    #          #                @gifts_list = Product.where(:gift_active=>true).tagged_with(@category_id, :on=>:category).tagged_with(@department_id, :on=>:department)
    #          #              end
    #          #              
    #          #            end
    #          #            # puts("=------------ gift list found ---------------")
    #          #            # puts(@gifts_list.inspect)
    #          #          rescue
    #          #            #  @gifts_list = Product.all
    #          #          end
    #          
    #          limits = params[:limit].blank? ? 100 : params[:limit].to_i
    #          
    #          @properties = Property.find(params[:search_by],params[:search_class], params[:search_term], limits)
    #    
    #          #          @gift_ids = @gifts_list.collect{|prod| prod.id }
    #          #
    #          #          @gift_count = @gifts_list.length
    #          #
    #          #          # @gifts = Kaminari.paginate_array(@gifts).page(params[:page]).per(@gifts_per_page)
    #          #          @gifts = Product.where(:id=>@gift_ids).order("gift_ranking DESC").order("position ASC").order("created_at DESC").page(params[:page]).per(@gifts_per_page)
    #          #          #    @gifts = @gifts.page(params[:page]).per(@gifts_per_page)
    #          #
    #          #          @gift_first = params[:page].blank? ? "1" : (params[:page].to_i*@gifts_per_page - (@gifts_per_page-1))
    #          #    
    #          #          @gift_last = params[:page].blank? ? @gifts.length : ((params[:page].to_i*@gifts_per_page) - @gifts_per_page) + @gifts.length || @gifts.length
    #          #
    #          #          system_action_template = (Settings.gift_list_template_name.blank? ? "show_gifts" : "show_gifts-" + Settings.gift_list_template_name) rescue "show_gifts"
    #          #          @action_template = params[:template].blank? ? system_action_template :  params[:template]
    #          #
    #          #                
    #          #          @java_script_custom = (@action_template != "show_gifts")  ? @action_template + ".js" : "" rescue ""
    #          #          @style_sheet_custom = (@action_template != "show_gifts") ? @action_template + ".css" : "" rescue ""
    #          #   
    #          
    #          respond_to do |format|
    #            format.html { render :action=>@action_template}
    #            format.xml  { render :xml => @properties }
    #          end
    #        end
    #  
    #
    #
    #       
    #        def property_detail
    #
    #          @property = Property.find(params[:id])
    #          
    #          #          if params[:next] then
    #          #            @gift = @gift.next_in_collection
    #          #            puts "=======NEXT========"
    #          #          end
    #          #    
    #          #          if params[:prev] then
    #          #            @gift = @gift.previous_in_collection
    #          #            puts "=======PREV======="
    #          #
    #          #          end
    #          #    
    #          session[:parent_menu_id] = 0
    #          
    #          @page_template = (not @gift.custom_layout.blank?) ? "property_detail-" + @gift.custom_layout : ("property_detail-" + Settings.gift_template_name rescue "property_detail") rescue "property_detail" 
    #          
    #          @java_script_custom = (@page_template != "property_detail")  ? @page_template + ".js" : "" rescue ""
    #          @style_sheet_custom = (@page_template != "property_detail") ? @page_template + ".css" : "" rescue ""
    #          @page_name = @gift.gift_name rescue "'Property' not found!!"
    #    
    #          @pictures = @gift.pictures.where(:active_flag=>true)
    #    
    #          @gift_details = @gift.gift_details
    #    
    #    
    #          respond_to do |format|
    #            format.html { render :action=>@page_template} # show.html.erb
    #            format.xml  { render :xml => @page }
    #          end
    #    
    #        end
    #
    #
    #
    #
    #  
    #        private 
    #  
    #  
    #        
    #        
    #      end
    #    
    #    end
  
  


  end

end