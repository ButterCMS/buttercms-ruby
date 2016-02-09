require 'json'
require 'rest_client'
require 'ostruct'

require 'buttercms/hash_to_object'
require 'buttercms/butter_collection'
require 'buttercms/butter_resource'
require 'buttercms/author'
require 'buttercms/category'
require 'buttercms/post'
require 'buttercms/feed'

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

    response = RestClient.get(endpoint + path,
      {accept: :json, authorization: "Token #{@token}", params: options})


    JSON.parse(response.body)
  end
end

