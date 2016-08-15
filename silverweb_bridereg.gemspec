$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "silverweb_bridereg/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "silverweb_bridereg"
  s.version     = SilverwebBridereg::VERSION
   s.authors     = ["Robert Lee Little III"]
  s.email       = ["rob@silverwebsystems.com"]
  s.homepage    = "http://www.silverwebsystems.com/"
  s.summary     = "This is a bridal registry gem that plugs into the silverweb ecom and silverweb cms gems."
  s.description = "Will create a series of models (bride, wish_list, etc) to manage bridal registries."
   s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"
  s.add_dependency 'silverweb_cms'
  s.add_dependency 'silverweb_ecom'
end
