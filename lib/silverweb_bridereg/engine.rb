module SilverwebBridereg
 class Engine < ::Rails::Engine
    
    # any requires here
    #require 'rets'
    #require 'gmaps4rails'   
    
    config.to_prepare do
#      SilverwebRealestate::Config.flexmls_initialize

#      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
#        require_dependency(c)
#      end
    end
    
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end


  end
end
