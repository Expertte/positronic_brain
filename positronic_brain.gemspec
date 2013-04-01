# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'positronic_brain/version'

Gem::Specification.new do |spec|
  spec.name          = 'positronic_brain'
  spec.version       = PositronicBrain::VERSION
  spec.authors       = ['Dalton']
  spec.email         = ['dalton@expertte.com']
  spec.description   = %q{A Toolbox of Artificial Intelligence designed to help to solve a wide range of problems}
  spec.summary       = %q{A Toolbox of Artificial Intelligence}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = Dir['{spec,bin,ext,lib}/**/*'] + ['LICENSE.txt', 'Rakefile', 'README.md', 'Gemfile']
  spec.test_files    = Dir['spec/**/*']

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'active_support'
  spec.add_dependency 'distribution'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'i18n'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
