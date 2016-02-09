require 'spec_helper'

describe ButterCMS::HashToObject do
  describe '.convert' do
    it 'converts hash to object' do
      hash = {
        "key1" => "value",
        "key2" => {
          "nested_key" => "nested value"
        }
      }

      obj = ButterCMS::HashToObject.convert(hash)

      expect(obj.key1).to eq 'value'
      expect(obj.key2.nested_key).to eq "nested value"
    end
  end
end