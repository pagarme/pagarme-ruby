# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "pagarme"
  spec.version       = "1.9.8"
  spec.authors       = ["Pedro Franceschi", "Henrique Dubugras"]
  spec.email         = ["pedrohfranceschi@gmail.com", "henrique@pagar.me"]
  spec.description   = %q{Pagar.me's ruby gem}
  spec.summary       = %q{Allows integration with Pagar.me}
  spec.homepage      = "http://pagar.me/"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency('shoulda', '~> 3.4.0')
  spec.add_development_dependency('test-unit')

  spec.add_dependency "rest-client"
  spec.add_dependency "multi_json"
end
