module ButterCMS
  class Content
    attr_reader :data

    def initialize(json)
      @json = json
      @data = HashToObject.convert(json["data"])
    end

    def inspect
      id_string = (self.respond_to?(:id) && !self.id.nil?) ? " id=#{self.id}" : ""
      "#<#{self.class}:0x#{self.object_id.to_s(16)}#{id_string}> JSON: " + JSON.pretty_generate(@json)
    end

    def self.fetch(keys = [])
      response = ButterCMS.request("/content", {keys: keys.join(',')})

      self.new(response)
    end
  end
end