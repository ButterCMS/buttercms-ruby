require 'spec_helper'

describe ButterCMS do
  describe '.request' do
    context 'with an api token' do
      before do
        ButterCMS.stub(:api_token).and_return('test123')
      end

      it 'should make an api request' do
        stub_request(:get, 'https://api.buttercms.com/v2?auth_token=test123').to_return(body: JSON.generate({data: {test: 'test'}}))
        expect{ ButterCMS.request('') }.to_not raise_error
      end
    end

    context 'without an api token' do
      it 'should throw an argument error' do
        expect{ ButterCMS.request() }.to raise_error(ArgumentError)
      end
    end
  end
end
