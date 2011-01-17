== Description
HTTMultiParty is a thin wrapper around HTTParty to provide multipart uploads.

== Requirements
Gems: httparty, multipart-post

== O RLY?
To start just "include HTTMultiParty" instead of "include HTTParty" into your client class.
When you pass a query with an instance of a File as a value for a PUT or POST request, the wrapper will 
use a bit of magic and multipart-post to execute a multipart upload:

== Example
<pre>
require 'lib/httmultiparty'
class SomeClient
  include HTTMultiParty
  base_uri 'http://localhost:3000'
end

SomeClient.post('/', :query => {:a => 1, :b => File.new('README.md')})
</pre>