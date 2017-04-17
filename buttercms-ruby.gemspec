# -*- encoding: utf-8 -*-
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'buttercms/version'

Gem::Specification.new do |s|
  s.name = "buttercms-ruby"
  s.version = ButterCMS::VERSION
  s.require_paths = ["lib"]
  s.summary = 'A simple Ruby client for the buttercms.com REST API'
  s.description = 'Butter is a blogging platform loved by engineers. See https://buttercms.com for details.'
  s.authors = ["ButterCMS"]
  s.email= ["support@buttercms.com"]
  s.homepage = "https://buttercms.com/docs"
  s.license = 'MIT'

  s.add_dependency 'httparty', '~> 0.14', '>= 0.14.0'

  s.add_development_dependency 'rspec', '~> 2.7'
  s.add_development_dependency 'webmock'
  s.required_ruby_version = '>= 1.9.3'

  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
end
