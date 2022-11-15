begin
  require 'redis'
rescue LoadError
  puts "WARNING: redis >= 3.0.0 is required to use the redis data store."
  raise
end

module ButterCMS
  module DataStoreAdapters
    class Redis
      def initialize(options)
        redis_param = options.first

        if redis_param.is_a?(String)
          @redis = ::Redis.new(url: redis_param)
        else # redis instance was passed in
          @redis = redis_param
        end
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
