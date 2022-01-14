# -*- encoding: utf-8 -*-
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'buttercms/version'

Gem::Specification.new do |s|
  s.name = "buttercms-ruby"
  s.version = ButterCMS::VERSION
  s.require_paths = ["lib"]
  s.summary = 'Ruby API client for ButterCMS'
  s.description = 'Butter is the #1 developer rated headless CMS. See https://buttercms.com for details.'
  s.authors = ["ButterCMS"]
  s.email= ["support@buttercms.com"]
  s.homepage = "https://buttercms.com/docs"
  s.license = 'MIT'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.required_ruby_version = '>= 1.9.3'

  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
end
