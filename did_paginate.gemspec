# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'did_paginate/version'

Gem::Specification.new do |spec|
  spec.name          = "did_paginate"
  spec.version       = DidPaginate::VERSION
  spec.authors       = ["Alex Petropavlovsky"]
  spec.email         = ["petalvlad@gmail.com"]
  spec.description   = 'did_paginate provides Rails view helper to build pagination component. This helper assumes that collection data has been already paginated, i.e. current page and total pages count are known.'
  spec.summary       = 'Renders pagination component for given current page and total pages count.'
  spec.homepage      = "https://github.com/petalvlad/did_paginate"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
