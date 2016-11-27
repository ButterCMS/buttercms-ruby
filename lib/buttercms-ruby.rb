require 'json'
require 'rest_client'
require 'ostruct'
require "redis"
require 'yaml/store'

require_relative 'buttercms/hash_to_object'
require_relative 'buttercms/butter_collection'
require_relative 'buttercms/butter_resource'
require_relative 'buttercms/author'
require_relative 'buttercms/category'
require_relative 'buttercms/tag'
require_relative 'buttercms/post'
require_relative 'buttercms/feed'
require_relative 'buttercms/content'

require_relative 'buttercms/data_store_adapters/yaml'
require_relative 'buttercms/data_store_adapters/redis'

# See https://github.com/jruby/jruby/issues/3113
if RUBY_VERSION < '2.0.0'
  require_relative 'core_ext/ostruct'
end

module ButterCMS
  @api_url = 'https://api.buttercms.com/v2'

  class <<self
    attr_accessor :api_token
    attr_reader :data_store
    attr_writer :logger
  end

  def self.logger
    @logger ||= Logger.new($stdout).tap do |log| 
      log.progname = "ButterCMS"
    end
  end

  def self.data_store=(*args)
    args.flatten!

    if args.count < 2
      raise ArgumentError.new "Wrong number of arguments"
    end
    
    strategy = args.first
    options = args.drop(1)

    case strategy
    when :yaml
      @data_store = ButterCMS::DataStoreAdapters::Yaml.new(options)
    when :redis
      @data_store = ButterCMS::DataStoreAdapters::Redis.new(options)
    else
      raise ArgumentError.new "Invalid ButterCMS data store #{strategy}"
    end
  end

  def self.api_request(path, options = {})
    response = RestClient::Request.execute(
      method: :get,
      url: @api_url + path,
      headers: {
        params: options.merge(auth_token: api_token)
      },
      verify_ssl: false
    )

    response.body
  end

  def self.request(path, options = {})
    raise ArgumentError.new "Please set your API token" unless api_token

    key = "buttercms:#{path}:#{options}"

    begin
      result = api_request(path, options)

      if data_store
        data_store.set(key, result) 
        logger.info "Set key #{key}"
      end

    # TODO - more selective exception handling (RestClient::Exception, SocketError)
    rescue Exception => e

      if data_store
        if result = data_store.get(key)
          logger.info "Fetched key #{key}"

          # Log request error
          logger.error e
        else
          logger.info "No data for key #{key}"
        end
      end

      # Raise request exception if there's no data store or value returned
      raise e unless data_store && result
    end

    return JSON.parse(result)
  end
end
