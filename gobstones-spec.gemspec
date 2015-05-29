# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gobstones/version'

Gem::Specification.new do |spec|
  spec.name          = 'gobstones-spec'
  spec.version       = Gobstones::VERSION
  spec.authors       = ['Federico Aloi', 'Franco Bulgarelli']
  spec.email         = ['federico.aloi@gmail.com', 'flbulgarelli@yahoo.com.ar']
  spec.summary       = 'Minimal test framework for the Gobstones language'
  spec.description   = 'Write Gobstones specs within Ruby'
  spec.homepage      = 'https://github.com/uqbar-project/gobstones-spec'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'gobgems', '0.0.4'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2'
  spec.add_development_dependency 'codeclimate-test-reporter'

end
