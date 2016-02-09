$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'webmock/rspec'
require 'buttercms-ruby'
