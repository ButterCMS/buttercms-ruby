module ButterCMS
  class Content
    def self.fetch(keys = [])
      ButterCMS.request("/content", {keys: keys.join(',')})
    end
  end
end