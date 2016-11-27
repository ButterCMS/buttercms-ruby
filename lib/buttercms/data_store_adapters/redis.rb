module ButterCMS
  module DataStoreAdapters
    class Redis
      def initialize(options)
        redis_url = options.first
        
        @redis = ::Redis.new(url: redis_url)
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