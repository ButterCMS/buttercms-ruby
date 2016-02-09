module ButterCMS
  class HashToObject
    def self.convert(hash)
      JSON.parse(hash.to_json, object_class: OpenStruct)
    end
  end
end