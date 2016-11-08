module SilverwebBridereg
  class Railtie < Rails::Railtie
    initializer "silverweb_bridereg.update_cloud_menu" do
          
      SilverwebCms::Config.add_nav_item({:name=>"Brides", :controller=>'brides', :action=>'index'})
        
      #    SilverwebCms::Config.add_nav_item({:name=>"Wish Lists", :controller=>'wish_lists', :action=>'index'})

      #    SilverwebCms::Config.add_menu_class(["Show Properties","menu_show_properties"])

      #    SilverwebCms::Config.add_menu_fields(["re_search_type","re_search_term", "re_search_param","re_search_class"])

    end
    
    initializer "Include your code in the controller" do
      ActiveSupport.on_load(:action_controller) do

        #  include SilverwebRealestate
        # SilverwebRealestate::Config.flexmls_initialize
      end
    end
    
    config.to_prepare do
      SiteController.send(:include, SilverwebBridereg::ControllerExtensions::SiteControllerExtensions)
      #    MenusController.send(:include, SilverwebEcom::ControllerExtensions::MenusControllerExtensions)

    end
    
    initializer "silverweb_bridereg.update_user_model" do 
      User.class_eval do
        has_one :bride
      end    
    end
    
    initializer "silverweb_bridereg.update_products_model" do 
      Product.class_eval do
        has_many   :gift_registries
      end    
    end
    
    initializer "silverweb_bridereg.update_order_items_model" do 
      OrderItem.class_eval do
        belongs_to   :bride
        
        def self.from_cart_item(cart_item, bride_id)
          if cart_item.quantity == 0 then
            nil
          else
            oi = self.new
            oi.product_id     = cart_item.product.id
            oi.product_detail_id = cart_item.product_detail.id
            oi.quantity    = cart_item.quantity
            oi.price = cart_item.price
            oi.color = cart_item.color
            oi.size = cart_item.size
            oi.title = cart_item.title
            oi.description =cart_item.description
            oi.bride_id = bride_id
            oi
          end
        end
      end    
    end
    
    initializer "silverweb_bridereg.update_orders_model" do 
      Order.class_eval do
        belongs_to   :bride

        clear_validators!

        validates_presence_of  :bill_first_name, :bill_last_name, :bill_street_1, :bill_city, :bill_state, :bill_zip


        def add_line_items_from_cart(cart, host, bride_id)
          cart.items.each do |item|
            li = OrderItem.from_cart_item(item, bride_id)
    
            order_items << li if (not li.nil?)
          end
  
          #  self.shipping_price= cart.shipping_cost
        end
      end
      
    end
    
    initializer "silverweb_bridereg.update_cart_model" do 
      Cart.class_eval do
        attr_reader :bride
        
        def bride=(bride)
          @bride=bride
        end
        
        def bride
          @bride
        end
        
        def add_product(product, product_detail, quantity, gift)
    
          current_item = @items.find {|item| item.product_detail.id == product_detail.id}
   

          if current_item.blank? then
            current_item = CartItem.new(product,product_detail, quantity, gift)
           
            @items << current_item

            if quantity.to_i  > product_detail.units_in_stock then
              current_item.quantity = product_detail.units_in_stock
              self.save
              raise("Exceeded inventory.")
            end
          else
            projected_quantity = current_item.quantity + quantity.to_i
            current_item.increment_quantity(quantity.to_i)
            if projected_quantity  > product_detail.units_in_stock then
              current_item.quantity = product_detail.units_in_stock
              self.save
              raise("Exceeded inventory.")
            end
          end

          self.save
          puts("current_item=> #{current_item.inspect}")
          return(current_item)
    
        end
  
        
        
      end    
    end
    
    initializer "silverweb_bridereg.update_cartitem_model" do 
      CartItem.class_eval do
        attr_reader :gift
        
        def gift=(gift)
          @gift=gift
        end
        
        def gift
          @gift
        end
        
        def initialize(product, product_detail, quantity, gift)
          puts("#{product.inspect}")
          puts("#{product_detail.inspect}")
          @product = product
          @product_detail = product_detail
          @quantity = quantity.to_i
          @gift = gift
        end
      end    
    end
    
    initializer "silverweb_bridereg.update_image_uploader" do 

      ImageUploader.class_eval do
        
        version :brid_reg_list_square do 
          process :resize_to_fill =>[245,245]
        end
      end
    end
  end
end