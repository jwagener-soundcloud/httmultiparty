require 'spec_helper'

class Client
  include HTTMultiParty
  base_uri 'http://example.com'
  default_params(token: 'test')
end

describe HTTMultiParty do
  let(:somefile) { File.new(File.join(File.dirname(__FILE__), '../fixtures/somefile.txt')) }

  it 'makes the request with correct query parameters' do
    FakeWeb.register_uri(:post, 'http://example.com/foobar?token=test', body: 'hello world')
    Client.post(
      '/foobar',
      body: {
        attachment: somefile
      }
    )
  end
end
