require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'buttercms-ruby', :path => '../buttercms-ruby'
end

# start a REPL session
ButterCMS::api_token = "" # add your dev token here
binding.irb