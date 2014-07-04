[![Build Status](https://travis-ci.org/jwagener/httmultiparty.svg?branch=v0.3.14)](https://travis-ci.org/jwagener/httmultiparty)


[![Gem Version](https://badge.fury.io/rb/httmultiparty.svg)](http://badge.fury.io/rb/httmultiparty)


## Description

HTTMultiParty is a thin wrapper around HTTParty to provide multipart uploads.

## Requirements

- httparty
- multipart-post
- mimemagic

## Quick Start and Example

To start just `include HTTMultiParty` instead of `include HTTParty` into
your client class. When you pass a query with an instance of a File as
a value for a PUT or POST request, the wrapper will use a bit of magic
and multipart-post to execute a multipart upload:

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
## File class support

Instead of using `File` class, you can use any class that responds to
a `read` method as a file object. If you are using Rails, you can use
`ActionDispatch::Http::UploadedFile` object directly as it responds to
`read` method. The `read` method should act similar to the `IO#read`
method. To set the filename your file class can optionally respond to
the `original_filename` method, which should return a `String`.
