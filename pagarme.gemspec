# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "pagarme"
  spec.version       = 0.14
  spec.authors       = ["Pedro Franceschi"]
  spec.email         = ["pedrohfranceschi@gmail.com"]
  spec.description   = %q{Gem do pagar.me para Ruby}
  spec.summary       = %q{Permite a integração com a API do pagar.me por Ruby.}
  spec.homepage      = "http://pagar.me/"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "rest-client"
  spec.add_dependency "multi_json"
end
