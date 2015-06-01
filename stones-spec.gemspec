# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stones-spec/version'

Gem::Specification.new do |spec|
  spec.name          = 'stones-spec'
  spec.version       = StonesSpec::VERSION
  spec.authors       = ['Federico Aloi', 'Franco Bulgarelli']
  spec.email         = ['federico.aloi@gmail.com', 'flbulgarelli@yahoo.com.ar']
  spec.summary       = 'Write specs for programs with Gobstones-like boards'
  spec.description   = 'Minimal test framework for any language with a Gobstones-like'
  spec.homepage      = 'https://github.com/uqbar-project/stones-spec'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'ruby-stones', '0.0.5'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2'
  spec.add_development_dependency 'codeclimate-test-reporter'

end
