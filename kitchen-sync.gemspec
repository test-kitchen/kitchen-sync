require "English"
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kitchen-sync/version"

Gem::Specification.new do |spec|
  spec.name          = "kitchen-sync"
  spec.version       = KitchenSync::VERSION
  spec.authors       = ["Noah Kantrowitz"]
  spec.email         = ["noah@coderanger.net"]
  spec.description   = "Improved file transfers for for test-kitchen"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/coderanger/kitchen-sync"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.add_dependency "test-kitchen", ">= 1.0.0"
  spec.add_dependency "net-sftp"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "cookstyle"
end
