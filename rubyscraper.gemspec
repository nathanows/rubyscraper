$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rubyscraper/version'

Gem::Specification.new do |s|
  s.name        = 'rubyscraper'
  s.version     = RubyScraper::VERSION
  s.licenses    = ['MIT']
  s.summary     = "Scrapes the sites..."
  s.description = "Scrapes job sites for job details and sends post request to server."
  s.authors     = ["Nathan Owsiany"]
  s.email       = 'nowsiany@gmail.com'
  s.files       = Dir["**/*"].select { |f| File.file? f  } - Dir['*.gem']
  s.homepage    = 'https://github.com/ndwhtlssthr/rubyscraper'
  s.executables << 'rubyscraper'

  s.add_dependency "capybara", "~> 2.4"
  s.add_dependency "poltergeist", "~> 1.6"
  s.add_dependency "rest-client", "~> 1.8"

  s.add_development_dependency "bundler", "~> 1.9"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "pry", "~> 0.10"
end
