# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jaspersoft/version'

Gem::Specification.new do |spec|
  spec.name          = "jaspersoft"
  spec.version       = Jaspersoft::VERSION
  spec.authors       = ["Peter Cunningham", "Darin Richardson"]
  spec.email         = ["peter@refreshmedia.com", "darin@refreshmedia.com"]
  spec.description   = %q{Access and process Jaspersoft Reports.}
  spec.summary       = %q{Access list of available reports and process/view available reports.}
  spec.homepage      = "https://github.com/oldbonsai/jaspersoft"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sawyer', '~> 0.5.1'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
