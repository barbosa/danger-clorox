# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = 'danger-clorox'
  spec.version       = DangerClorox::VERSION
  spec.authors       = ['Gustavo Barbosa']
  spec.email         = ['gustavocsb@gmail.com']
  spec.description   = %q{A Danger plugin for checking presence of file header comments.}
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/barbosa/danger-clorox'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'danger'

  # General ruby development
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.0'

  #  Testing support
  spec.add_development_dependency "rspec", '~> 3.4'

  # Makes testing easy via `bundle exec guard`
  spec.add_development_dependency "guard", '~> 2.14'
  spec.add_development_dependency "guard-rspec", '~> 4.7'

  # If you want to work on older builds of ruby
  spec.add_development_dependency "listen", '3.0.7'

  # This gives you the chance to run a REPL inside your test
  # via
  #    binding.pry
  # This will stop test execution and let you inspect the results
  spec.add_development_dependency "pry"

end
