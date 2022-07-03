require 'spec_helper'

describe ButterCMS do
  describe '.request' do
    context 'with an api token' do
      before do
        allow(ButterCMS).to receive(:api_token).and_return('test123')
      end

      it 'should make an api request' do
        request = stub_request(:get, "https://api.buttercms.com/v2?auth_token=test123")
          .to_return(body: JSON.generate({data: {test: 'test'}}))

        ButterCMS.request('')
        expect(request).to have_been_made
      end

      it "should properly escape paths" do
        request = stub_request(
          :get,
          "https://api.buttercms.com/v2/pages/*/homepage%20en?auth_token=test123"
        ).to_return(body: JSON.generate({data: {test: 'test'}}))

        # support leading slashes
        ButterCMS.request('/pages/*/homepage en')

        # and no leading slashes
        ButterCMS.request('pages/*/homepage en')


        expect(request).to have_been_made.twice
      end
    end

    context 'without an api token' do
      it 'should throw an argument error' do
        expect{ ButterCMS.request() }.to raise_error(ArgumentError)
      end
    end

    it "raises NotFound on 404" do
      allow(ButterCMS).to receive(:api_token).and_return("test123")

      request = stub_request(:get, %r{/posts/slug/})
        .with(query: { auth_token: "test123" })
        .to_return(status: 404, body: '{"detail":"Not found."}')

      expect { ButterCMS.request("/posts/slug/") }
        .to raise_error(ButterCMS::NotFound)

      expect(request).to have_been_made
    end

    it "raises Unauthorized on 401" do
      allow(ButterCMS).to receive(:api_token).and_return("test")

      request = stub_request(:get, %r{/posts/slug/})
        .with(query: { auth_token: "test" })
        .to_return(status: 401, body: '{"detail":"Invalid token."}')

      expect { ButterCMS.request("/posts/slug/") }
        .to raise_error(ButterCMS::Unauthorized)

      expect(request).to have_been_made
    end
  end
end
