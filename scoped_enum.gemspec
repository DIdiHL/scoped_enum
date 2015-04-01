# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scoped_enum/version'

Gem::Specification.new do |spec|
  spec.name          = 'scoped_enum'
  spec.version       = ScopedEnum::VERSION
  spec.authors       = ['Lin Han']
  spec.email         = ['hanlin.dev@gmail.com']

  spec.summary       = 'Add scopes to enums easily'
  spec.homepage      = 'https://github.com/DIdiHL/scoped_enum.git'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://github.com'
  end

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "factory_girl_rails", "~> 4.0"
  spec.add_development_dependency 'activerecord', '~> 4.1.0'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'sqlite3'
end
