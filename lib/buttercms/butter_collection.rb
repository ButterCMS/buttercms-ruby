module ButterCMS
  class ButterCollection
    include Enumerable

    attr_reader :items
    attr_reader :meta

    def initialize(klass, json)
      data = json["data"]
      meta = json["meta"]

      @meta = HashToObject.convert(meta) if meta
      @items = data.map {|o| klass.new("data" => o) }
    end

    def each(&block)
      @items.each do |member|
        block.call(member)
      end
    end
  end
end
