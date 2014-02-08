## Description

HTTMultiParty is a thin wrapper around HTTParty to provide multipart uploads.

## Requirements

- httparty
- multipart-post
- mimemagic

## Quick Start and Example

To start just "include HTTMultiParty" instead of "include HTTParty" into
your client class. When you pass a query with an instance of a File as a value for a PUT or POST request, the wrapper will use a bit of magic and multipart-post to execute a multipart upload:

```ruby
require 'httmultiparty'
class SomeClient
  include HTTMultiParty
  base_uri 'http://localhost:3000'
end

response = SomeClient.post('/', :query => {
  :foo      => 'bar',
  :somefile => File.new('README.md')
})
```

Aside from that it provides all the usual HTTParty gimmicks.

## MIME type support

If you want the library to detect the MIME types of the uploaded files, then
you need to enable it by supplying the `:detect_mime_type` option as `true`
for POST or PUT requests. Otherwise, they will be uploaded with the default
MIME type of `application/octet-stream`. For example:

```ruby
require 'httmultiparty'
class SomeClient
  include HTTMultiParty
  base_uri 'http://localhost:3000'
end

response = SomeClient.post('/', :query => {
  :foo      => 'bar',
  :somefile => File.new('README.md')
}, :detect_mime_type => true)
```


