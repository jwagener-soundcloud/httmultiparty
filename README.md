HTTMultiParty is a thin wrapper around HTTParty to allow multipart uploads.
To start just "include HTTMultiParty" instead of "include HTTParty" into your client class.
When you pass a query with an instance of a File as a value for a PUT or POST request, the wrapper will use 
Net::Http:Post::Multipart provided by the multipart-post gem instead.
client.post('http://example.com', {:file_param => File.new('somefile')})
