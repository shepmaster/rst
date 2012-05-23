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
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rake','~> 0.9.2')
  gem.add_dependency('methadone', '~>1.2.0')
end
