# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'httmultiparty/version'

Gem::Specification.new do |s|
  s.name        = 'httmultiparty'
  s.version     = HTTMultiParty::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Johannes Wagener']
  s.email       = ['johannes@wagener.cc']
  s.homepage    = 'http://github.com/jwagener/httmultiparty'
  s.summary     = 'HTTMultiParty is a thin wrapper around HTTParty to provide multipart uploads.'
  s.description = 'HTTMultiParty is a thin wrapper around HTTParty to provide multipart uploads.'
  s.license     = 'MIT'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_dependency 'httparty', '>= 0.7.3'
  s.add_dependency 'multipart-post'
  s.add_dependency 'marcel'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakeweb'

  s.files        = Dir.glob('{lib}/**/*') + %w(README.md)
  s.require_path = 'lib'
end
