module ButterCMS
  class Post < ButterResource
    def self.resource_path
      "/posts/"
    end

    def self.search(query = '', options = {})
      response = ButterCMS.request('/search/', {query: query}.merge(options))

      self.create_collection(response)
    end
  end
end
