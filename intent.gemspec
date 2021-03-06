# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'intent/version'

Gem::Specification.new do |spec|
  spec.name          = "intent"
  spec.version       = Intent::VERSION
  spec.authors       = ["Mark Rickerby"]
  spec.email         = ["me@maetl.net"]

  spec.summary       = "Text-based project management"
  spec.homepage      = "http://maetl.net"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "todo-txt", "~> 0.11"
  spec.add_runtime_dependency "pastel", "~> 0.6"
  spec.add_runtime_dependency "git", "~> 1.3.0"
  spec.add_runtime_dependency "terminal-notifier", "~> 1.8.0"
  spec.add_runtime_dependency "ghost", "~> 1.0.0"


  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
