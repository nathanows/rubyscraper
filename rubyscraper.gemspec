# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubyscraper/version'

Gem::Specification.new do |spec|
  spec.name          = "rubyscraper"
  spec.version       = RubyScraper::VERSION
  spec.authors       = ["Nathan Owsiany"]
  spec.email         = ["nowsiany@gmail.com"]

  spec.summary       = %q{Scrapes job sites for job details and send post request to server.}
  spec.description   = %q{Scrapes the sites...}
  spec.homepage      = "https://github.com/ndwhtlssthr/rubyscraper"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara"
  spec.add_dependency "poltergeist"
  spec.add_dependency "rest-client"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
