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
end
