require 'json'
require 'ostruct'
require 'logger'
require 'uri'
require 'net/http'

require "buttercms/errors"
require 'buttercms/version'
require 'buttercms/hash_to_object'
require 'buttercms/butter_collection'
require 'buttercms/butter_resource'
require 'buttercms/author'
require 'buttercms/category'
require 'buttercms/tag'
require 'buttercms/post'
require 'buttercms/feed'
require 'buttercms/content'
require 'buttercms/page'

# See https://github.com/jruby/jruby/issues/3113
if RUBY_VERSION < '2.0.0'
  require_relative 'core_ext/ostruct'
end

module ButterCMS
  @api_url = URI.parse('https://api.buttercms.com/v2')

  class << self
    attr_accessor :api_token
    attr_accessor :write_api_token
    attr_accessor :test_mode
    attr_accessor :read_timeout
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
      require_relative 'buttercms/data_store_adapters/yaml'
      @data_store = ButterCMS::DataStoreAdapters::Yaml.new(options)
    when :redis
      require_relative 'buttercms/data_store_adapters/redis'
      @data_store = ButterCMS::DataStoreAdapters::Redis.new(options)
    else
      raise ArgumentError.new "Invalid ButterCMS data store #{strategy}"
    end
  end

  def self.api_request(path, options = {})
    query = options.dup
    query[:auth_token] ||= api_token

    if test_mode
      query[:test] = 1
    end

    path = "#{@api_url.path}#{URI.encode(path)}?#{URI.encode_www_form(query)}"

    response =
      Net::HTTP.start(@api_url.host, @api_url.port, http_options) do |http|
        request = Net::HTTP::Get.new(path)
        request["User-Agent"] = "ButterCMS/Ruby #{ButterCMS::VERSION}"
        request["Accept"]     = "application/json"

        http.request(request)
      end

    case response
    when Net::HTTPNotFound
      raise ::ButterCMS::NotFound, JSON.parse(response.body)["detail"]
    end

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

    # TODO - more selective exception handling (SocketError)
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
  
  def self.write_request(path, options = {})
    raise ArgumentError.new "Please set your write API token" unless write_api_token
    result = write_api_request(path, options)

    return JSON.parse(result)
  end
  
  def self.write_api_request(path, options = {})
    query = options.dup
    token_for_request = query.delete(:auth_token) || write_api_token

    path = "#{@api_url.path}#{URI.encode(path)}"

    response =
      Net::HTTP.start(@api_url.host, @api_url.port, http_options) do |http|
        write_type = query.delete(:method) || "Post"
        request_type = "Net::HTTP::#{write_type}".constantize
        request = request_type.new(path)
        request["User-Agent"] = "ButterCMS/Ruby #{ButterCMS::VERSION}"
        request["Accept"]     = "application/json"
        request["Content-Type"] = "application/json"
        request["Authorization"] = "Token #{token_for_request}"
        request.body = query.except(:auth_token).to_json

        http.request(request)
      end

    puts "response from butter"
    puts response.inspect
    puts JSON.parse(response.body)["detail"]
    case response
    when Net::HTTPNotFound
      raise ::ButterCMS::NotFound, JSON.parse(response.body)["detail"]
    when Net::HTTPBadRequest
      raise ::ButterCMS::BadRequest, JSON.parse(response.body)["detail"]
    end

    response.body
  end
  
  private
  
  def self.http_options
    {
      open_timeout: 2.0,
      read_timeout: read_timeout || 5.0,
      ssl_timeout:  2.0,
      use_ssl:      @api_url.scheme == "https",
    }
  end
end
