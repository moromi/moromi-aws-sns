# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moromi/aws/sns/version'

Gem::Specification.new do |spec|
  spec.name          = "moromi-aws-sns"
  spec.version       = Moromi::Aws::Sns::VERSION
  spec.authors       = ["Takahiro Ooishi"]
  spec.email         = ["taka0125@gmail.com"]

  spec.summary       = %q{AWS SNS client.}
  spec.description   = %q{AWS SNS client.}
  spec.homepage      = "https://github.com/moromi/moromi-aws-sns"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2'

  spec.add_dependency 'aws-sdk-sns', '~> 1'
  spec.add_dependency 'activesupport', ['>= 4.2']

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
