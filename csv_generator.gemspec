# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csv_generator/version'

Gem::Specification.new do |spec|
  spec.name          = 'csv_generator'
  spec.version       = CsvGenerator::VERSION
  spec.authors       = ['SAWADA Tadashi']
  spec.email         = ['cesare@mayverse.jp']
  spec.summary       = %q(CSV generator library)
  spec.description   = %q(CSV generator with ensuring string fields quoted)
  spec.homepage      = 'https://github.com/cesare/csv_generator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rubocop', '~> 0.27'
end
