# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ox/builder/version'

Gem::Specification.new do |gem|
  gem.name          = "ox-builder"
  gem.version       = Ox::Builder::VERSION
  gem.authors       = ["Daniel Vandersluis"]
  gem.email         = ["dvandersluis@selfmgmt.com"]

  gem.summary       = %q{XML Builder for Rails using ox}
  gem.homepage      = "https://www.github.com/dvandersluis/ox-builder"
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.11"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency 'actionpack', ['~> 3.2']
  gem.add_development_dependency 'activesupport', ['~> 3.2']

  gem.add_dependency 'ox', ['~> 2.3.0']
  gem.add_dependency 'docile', ['~> 1.1.5']
end
