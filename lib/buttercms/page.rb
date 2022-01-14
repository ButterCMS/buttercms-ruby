module ButterCMS
  class Page < ButterResource
    def self.resource_path
      "/pages/"
    end

    def self.list(page_type, options = {})
      response = ButterCMS.request(self.endpoint(page_type), options)

      self.create_collection(response)
    end

    def self.get(page_type, slug, options = {})
      response = ButterCMS.request(self.endpoint("#{page_type}/#{slug}"), options)

      self.create_object(response)
    end

    def self.search(query = '', options = {})
      response = ButterCMS.request('/pages/search/', {query: query}.merge(options))
      
      self.create_collection(response)
    end
  end
end
