HTTMultiParty is a thin wrapper around HTTParty to provide multipart uploads.
To start just "include HTTMultiParty" instead of "include HTTParty" into your client class.
When you pass a query with an instance of a File as a value for a PUT or POST request, the wrapper will use 
Net::HTTP::Post::Multipart or Net::HTTP::Put::Multipart provided by the multipart-post gem instead.
client.post('http://example.com', {:file_param => File.new('somefile')})


--
require 'lib/httmultiparty'
class SomeClient
  include HTTMultiParty
  base_uri 'http://localhost:3000'
end

SomeClient.post('/', :query => {:a => 1, :b => File.new('README.md')})
--




