require 'spec_helper'

describe ButterCMS::ButterResource do
  before do
    allow(ButterCMS).to receive(:token).and_return('test123')
    allow(ButterCMS).to receive(:request).and_return({"data" => [{"attribute" => 'test'}]})

    allow(ButterCMS::ButterResource).to receive(:resource_path).and_return('')
  end

  describe 'auto-generated methods' do
    let(:resource) { described_class.new('data' => { 'name' => 'Test Name', 'description' => 'Test Description' }) }

    it 'creates attribute reader methods for data pairs' do
      aggregate_failures do
        expect(resource.name).to eq('Test Name')
        expect(resource.description).to eq('Test Description')
      end
    end
  end

  describe '.all' do

    it 'should make a request with the correct endpoint' do
      expect(ButterCMS).to receive(:request).with('', {})
      ButterCMS::ButterResource.all()
    end

    it 'should return a collection' do
      objects = ButterCMS::ButterResource.all
      expect(objects).to be_a(ButterCMS::ButterCollection)
      expect(objects.first).to be_a(ButterCMS::ButterResource)
    end
  end

  describe '.find' do
    it 'should make a request with the correct endpoint' do
      expect(ButterCMS).to receive(:request).with('1/', {})
      ButterCMS::ButterResource.find(1)
    end

    it 'should return one object' do
      expect(ButterCMS::ButterResource.find(1)).to be_a(ButterCMS::ButterResource)
    end
  end
end
