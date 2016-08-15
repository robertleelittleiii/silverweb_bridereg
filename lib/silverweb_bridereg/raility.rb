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
  end
end