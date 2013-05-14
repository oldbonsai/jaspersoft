# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jaspersoft/version'
require 'psych'

Gem::Specification.new do |spec|
  spec.name          = "jaspersoft"
  spec.version       = Jaspersoft::VERSION
  spec.authors       = ["Peter Cunningham"]
  spec.email         = ["peter@refreshmedia.com"]
  spec.description   = %q{Access and process Jaspersoft Reports.}
  spec.summary       = %q{Access list of available reports and process/view available reports.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "nokogiri"
  spec.add_dependency "active_support"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
