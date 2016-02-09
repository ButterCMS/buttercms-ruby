require 'spec_helper'

describe ButterCMS::ButterResource do
  describe '.all' do
    before do
      ButterCMS.stub(:token).and_return('test123')
      ButterCMS.stub(:request).and_return({"data" => [{"attribute" => 'test'}]})

      ButterCMS::ButterResource.stub(:resource_path).
        and_return('')
    end

    it 'should make a request with the correct endpoint' do
      expect(ButterCMS).to receive(:request).with('/', {})
      ButterCMS::ButterResource.all()
    end

    it 'should return a collection' do
      objects = ButterCMS::ButterResource.all
      expect(objects).to be_a(ButterCMS::ButterCollection)
      expect(objects.first).to be_a(ButterCMS::ButterResource)
    end
  end

  describe '.find' do
    before do
      ButterCMS.stub(:token).and_return('test123')
      ButterCMS.stub(:request).and_return({"data" => {"attribute" => 'test'}})

      ButterCMS::ButterResource.stub(:resource_path).
        and_return('')
    end

    it 'should make a request with the correct endpoint' do
      expect(ButterCMS).to receive(:request).with('/1', {})
      ButterCMS::ButterResource.find(1)
    end

    it 'should return one object' do
      expect(ButterCMS::ButterResource.find(1)).to be_a(ButterCMS::ButterResource)
    end
  end
end
