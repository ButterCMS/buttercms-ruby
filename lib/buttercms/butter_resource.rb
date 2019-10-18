module ButterCMS
  class ButterResource
    attr_reader :meta, :data

    def initialize(json)
      @json = json
      @data = HashToObject.convert(json["data"])
      @meta = HashToObject.convert(json["meta"]) if json["meta"]

      if json["data"].is_a?(Hash)
        json["data"].each do |key, value|
          instance_variable_set("@#{key}", @data.send(key))
          self.class.send(:attr_reader, key)
        end
      end
    end

    def inspect
      id_string = (self.respond_to?(:id) && !self.id.nil?) ? " id=#{self.id}" : ""
      "#<#{self.class}:0x#{self.object_id.to_s(16)}#{id_string}> JSON: " + JSON.pretty_generate(@json)
    end

    def self.endpoint(id = nil)
      # Append trailing slash when id is added to path because
      # API expects all endpoints to include trailing slashes
      resource_path + (id ? "#{id}/" : '')
    end
    
    def self.patch_endpoint(id)
      # Append trailing slash when id is added to path because
      # API expects all endpoints to include trailing slashes
      resource_path + "*/#{id}/"
    end

    def self.resource_path
      raise "resource_path must be set"
    end

    def self.all(options = {})
      response = ButterCMS.request(self.endpoint, options)

      self.create_collection(response)
    end

    def self.find(id, options = {})
      response = ButterCMS.request(self.endpoint(id), options)

      self.create_object(response)
    end
    
    def self.create(options = {})
      options[:method] = 'Post'
      response = ButterCMS.write_request(self.endpoint, options)

      self.create_object(response)
    end
    
    def self.update(id, options = {})
      options[:method] = 'Patch'
      _endpoint = if resource_path.include?("/pages/")
        self.patch_endpoint(id)
      else
        self.endpoint(id)
      end
      response = ButterCMS.write_request(_endpoint, options)

      self.create_object(response)
    end

    private

    def self.create_collection(response)
      ButterCollection.new(self, response)
    end

    def self.create_object(response)
      self.new(response)
    end
  end
end
