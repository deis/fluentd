# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-deis_output"
  gem.version       = "0.1.0"
  gem.authors       = ["engineering@deis"]
  gem.email         = ["engineering@deis.com"]
  gem.description   = %q{Fluentd output plugin for sending data to Deis Components }
  gem.summary       = %q{Fluentd output plugin for sending data to Deis Components}
  gem.homepage      = "https://github.com/deis/fluentd"
  gem.license       = "ASL2"

  gem.files         = Dir.glob("{lib}/**/*") + %w(LICENSE README.md)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.has_rdoc      = false

  gem.required_ruby_version = '>= 2.0.0'

  gem.add_runtime_dependency "fluentd"
  gem.add_runtime_dependency "fluent-mixin-plaintextformatter"
  gem.add_runtime_dependency "fluent-mixin-config-placeholders"
  gem.add_runtime_dependency "fluent-mixin-rewrite-tag-name"
  gem.add_runtime_dependency "influxdb", '~> 0.3'
  gem.add_runtime_dependency "nsq-ruby"

  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "test-unit", "~> 3.1.7"
end
