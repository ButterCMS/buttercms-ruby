require 'json'
require 'rest_client'
require 'ostruct'

require_relative 'buttercms/hash_to_object'
require_relative 'buttercms/butter_collection'
require_relative 'buttercms/butter_resource'
require_relative 'buttercms/author'
require_relative 'buttercms/category'
require_relative 'buttercms/tag'
require_relative 'buttercms/post'
require_relative 'buttercms/feed'
require_relative 'buttercms/content'

# See https://github.com/jruby/jruby/issues/3113
if RUBY_VERSION < '2.0.0'
  require_relative 'core_ext/ostruct'
end

module ButterCMS
  @api_url = 'https://api.buttercms.com/v2'
  @token = nil

  def self.api_token=(token)
    @token = token
  end

  def self.token
    @token
  end

  def self.endpoint
    @api_url
  end

  def self.request(path, options = {})
    raise ArgumentError.new "Please set your API token" unless token

    response = RestClient::Request.execute(
      method: :get,
      url: endpoint + path,
      headers: {
        params: options.merge(auth_token: @token)
      },
      verify_ssl: false
    )

    JSON.parse(response.body)
  end
end

