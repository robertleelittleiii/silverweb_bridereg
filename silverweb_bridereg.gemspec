$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "silverweb_bridereg/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "silverweb_bridereg"
  s.version     = SilverwebBridereg::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of SilverwebBridereg."
  s.description = "TODO: Description of SilverwebBridereg."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"

  s.add_development_dependency "sqlite3"
end
