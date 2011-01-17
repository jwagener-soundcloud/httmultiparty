<h2>Description</h2>
<p>HTTMultiParty is a thin wrapper around HTTParty to provide multipart uploads.</p>

<h2>Requirements</h2>
<ul>
  <li>httparty</li>
  <li>multipart-post</li>
</ul>

<h2>O RLY?</h2>
<p>To start just "include HTTMultiParty" instead of "include HTTParty" into your client class.
When you pass a query with an instance of a File as a value for a PUT or POST request, the wrapper will 
use a bit of magic and multipart-post to execute a multipart upload:</p>

<h2>Example</h2>
<pre>
require 'lib/httmultiparty'
class SomeClient
  include HTTMultiParty
  base_uri 'http://localhost:3000'
end

response = SomeClient.post('/', :query => {
    :foo      => 'bar',
    :somefile => File.new('README.md')
  })
</pre>