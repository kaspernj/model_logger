$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "model_logger/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "model_logger"
  s.version     = ModelLogger::VERSION
  s.authors     = ["kaspernj"]
  s.email       = ["kaspernj@gmail.com"]
  s.homepage    = "https://github.com/kaspernj/model_logger"
  s.summary     = "A small gem for logging stuff on models."
  s.description = "A small gem for logging stuff on models."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sqlite3"
end
