begin
  require 'redis'
rescue LoadError
  puts "WARNING: redis >= 3.0.0 is required to use the redis data store."
  raise
end

module ButterCMS
  module DataStoreAdapters
    class RedisSSL
      def initialize(options)
        redis_url = options.first
        ssl_params = options.second && Hash.new(options.second)

        @redis = ::Redis.new(url: redis_url, ssl_params:)
      end

      def set(key, value)
        @redis.set(key, value)
      end

      def get(key)
        @redis.get(key)
      end
    end
  end
end
