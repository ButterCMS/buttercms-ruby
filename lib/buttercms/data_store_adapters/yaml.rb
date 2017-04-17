require 'yaml/store'

module ButterCMS
  module DataStoreAdapters
    class Yaml
      def initialize(options)
        file_path = options.first

        @store = YAML::Store.new file_path
      end

      def set(key, value)
        @store.transaction do
          @store[key] = value
        end
      end

      def get(key)
        @store.transaction do
          @store[key]
        end
      end
    end
  end
end
