module ButterCMS
  class ButterResource
    attr_reader :meta, :data

    def initialize(json)
      data = json["data"]
      meta = json["meta"]

      @json = json
      @data = HashToObject.convert(data)
      @meta = HashToObject.convert(meta) if meta

      data.each do |key, value|
        instance_variable_set("@#{key}", @data.send(key))
        self.class.send(:attr_reader, key)
      end
    end

    def inspect
      id_string = (self.respond_to?(:id) && !self.id.nil?) ? " id=#{self.id}" : ""
      "#<#{self.class}:0x#{self.object_id.to_s(16)}#{id_string}> JSON: " + JSON.pretty_generate(@json)
    end

    def self.endpoint(id = '')
      resource_path + '/' + id.to_s
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

    private

    def self.create_collection(response)
      ButterCollection.new(self, response)
    end

    def self.create_object(response)
      self.new(response)
    end
  end
end
