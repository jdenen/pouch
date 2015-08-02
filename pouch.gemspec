# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pouch/version'

Gem::Specification.new do |spec|
  spec.name          = "pouch"
  spec.version       = Pouch::VERSION
  spec.authors       = ["Johnson Denen"]
  spec.email         = ["jdenen@manta.com"]
  spec.summary       = %q{A flexible page object DSL for responsive UI testing}
  spec.description   = %q{A flexible page object DSL for responsive UI testing}
  spec.homepage      = "https://github.com/jdenen/pouch"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "watir-webdriver", "~> 0.6.11"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "simplecov", "~> 0.10"
end
