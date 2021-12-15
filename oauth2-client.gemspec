lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oauth2-client/version'
require 'date'

Gem::Specification.new do |spec|
  spec.authors          = ['Kevin Mutyaba']
  spec.date             = Date.today.to_s
  spec.description      = 'Create quick and dirty OAuth2 clients'
  spec.email            = 'tiabasnk@gmail.com'
  spec.files            = `git ls-files`.split("\n")
  spec.homepage         = 'http://tiabas.github.com/oauth2-client/'
  spec.licenses         = ['MIT']
  spec.name             = 'oauth2-client'
  spec.require_paths    = ['lib']
  spec.required_rubygems_version = '>= 1.3'
  spec.summary          = 'OAuth2 client wrapper in Ruby'
  spec.version          = OAuth2Client::Version

  spec.cert_chain       = ['certs/tiabas-public.pem']
  spec.signing_key      = File.expand_path('~/.gem/certs/private_key.pem') if $0 =~ /gem\z/

  spec.add_dependency 'addressable'
  spec.add_dependency 'bcrypt-ruby'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
end
