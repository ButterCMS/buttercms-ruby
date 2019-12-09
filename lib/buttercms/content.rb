module ButterCMS
  class Content < ButterResource
    def self.resource_path
      "/content/"
    end

    def self.list(collection_slug, options = {})
      response = ButterCMS.request(self.endpoint(collection_slug), options)

      self.create_collection(response)
    end
    
    def self.fetch(collection_slugs, options = {})
      params = { keys: collection_slugs.join(',') }.merge(options)
      response = ButterCMS.request(self.resource_path, params)
      
      self.create_collection(response)
    end
  end
end