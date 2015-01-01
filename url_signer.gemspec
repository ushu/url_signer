# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'url_signer/version'

Gem::Specification.new do |spec|
  spec.name          = "url_signer"
  spec.version       = UrlSigner::VERSION
  spec.authors       = ["Aurélien Noce"]
  spec.email         = ["aurnoce@gmail.com"]
  spec.summary       = %q{Sign and verify URLs}
  spec.description   = %q{Simple solution (2 methods) to sign URLs and verify the generated URLs. Use HAMC/SHA1 for signing by default but can be configured.}
  spec.homepage      = "https://github.com/ushu/url_signer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
end
