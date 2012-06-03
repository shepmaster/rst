# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rst/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Carol Nichols"]
  gem.email         = ["carol.nichols@gmail.com"]
  gem.description   = %q{A command line client for rstat.us}
  gem.summary       = %q{A command line client for rstat.us}
  gem.homepage      = "https://github.com/clnclarinet/rst"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rst"
  gem.require_paths = ["lib"]
  gem.version       = Rst::VERSION
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('aruba', '~> 0.4.11')
  gem.add_development_dependency('minitest', '~> 2.12.1')
  gem.add_development_dependency('mocha', '~> 0.11.3')
  gem.add_development_dependency('rake','~> 0.9.2')
  gem.add_development_dependency('vcr', '~> 2.1.1')

  gem.add_dependency('gli', '~> 1.6.0')
  gem.add_dependency('typhoeus', '~> 0.3.3')
  gem.add_dependency('nokogiri', '~> 1.5.2')
end
