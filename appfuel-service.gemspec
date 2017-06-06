# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "appfuel/service/version"

Gem::Specification.new do |spec|
  spec.name          = "appfuel-service"
  spec.version       = Appfuel::Service::VERSION
  spec.authors       = ["Robert Scott-Buccleuch"]
  spec.email         = ["rsb.code@gmail.com"]
  spec.licenses      = 'MIT'
  spec.summary       = %q{Allow Appfuel to work as a micro service}
  spec.description   = %q{Microsevice implementation using Sneakers and RabbitMQ}
  spec.homepage      = "https://github.com/rsb/appfuel-service"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "appfuel",  "~> 0.2.6"
  spec.add_dependency "sneakers", "~> 2.5"

  spec.add_development_dependency "bundler",  "~> 1.15"
  spec.add_development_dependency "rake",     "~> 10.0"
  spec.add_development_dependency "rspec",    "~> 3.6"
end
