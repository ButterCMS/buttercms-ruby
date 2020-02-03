require 'spec_helper'

describe ButterCMS::ButterCollection do
  let(:json) { {"data" => ["foo"], "meta" => {}} }
  let(:klass) { double('klass', :new => 'bar') }

  it 'implements #items' do
    collection = ButterCMS::ButterCollection.new(klass, json)

    expect(collection.items).to match_array(["bar"])
  end

  it 'implements #meta' do
    collection = ButterCMS::ButterCollection.new(klass, json)

    expect(collection.meta).to be_a(OpenStruct)
  end

  it 'implements #count' do
    collection = ButterCMS::ButterCollection.new(klass, json)

    expect(collection.count).to eq 1
  end

  # Marshal.load (used by Rails for caching) was not restoring the ButterResource's dynamic methods
  # See https://github.com/ButterCMS/buttercms-ruby/issues/13
  describe 'marshal load' do
    subject { described_class.new(ButterCMS::ButterResource, 'data' => [{ 'name' => 'Test Name', 'description' => 'Test Description' }]) }

    it 'restores the ButterResource dynamic methods' do
      collection = Marshal.load(Marshal.dump(subject))
      resource = collection.first

      aggregate_failures do
        expect(resource.name).to eq('Test Name')
        expect(resource.description).to eq('Test Description')
      end
    end
  end
end
